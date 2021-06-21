# resource "aws_launch_configuration" "ecs_launch_config" {
#   image_id             = data.aws_ami.aws-linux.id
#   iam_instance_profile = aws_iam_role.ecs_instance_role.name
#   security_groups      = [aws_security_group.nginx-sg.id, aws_security_group.elb-sg.id, aws_security_group.rds_sg.id]
#   # security_groups = [aws_security_group.nginx-sg.id]
#   user_data     = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config"
#   instance_type = "t2.micro"
# }

# resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
#   name = "asg"
#   vpc_zone_identifier = [
#     aws_subnet.subnet1.id,
#     aws_subnet.subnet2.id
#   ]
#   launch_configuration = aws_launch_configuration.ecs_launch_config.name

#   desired_capacity          = 2
#   min_size                  = 1
#   max_size                  = 10
#   health_check_grace_period = 300
#   health_check_type         = "EC2"
# }

resource "aws_iam_instance_profile" "quizzer-ecs-instance-profile" {
  name = "${local.name_prefix}-quizzer-ecs-instance-profile"
  role = aws_iam_role.quizzer-ecs-instance-role.name
}

resource "aws_iam_role" "quizzer-ecs-instance-role" {
  name               = "${local.name_prefix}-quizzer-ecs-instance-role"
  assume_role_policy = data.aws_iam_policy_document.quizzer-ecs-policy-doc.json
  tags = local.common_tags
}

data "aws_iam_policy_document" "quizzer-ecs-policy-doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "quizzer-ecs-rpa" {
  role       = aws_iam_role.quizzer-ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_ecs_cluster" "quizzer-ecs-cluster" {
  name = "${local.name_prefix}-quizzer-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge(local.common_tags, {
    Name = "ecs cluster"
  })
}
resource "aws_ecs_task_definition" "quizzer-td" {
  family = "quizzer-service"
  container_definitions = templatefile(
    "${path.module}/task_definition.json.tpl",
    {
      REPOSITORY_URL = "ghcr.io/techlibplanet/sample-project",/*aws_ecr_repository.quizzer-ecr-repo.repository_url,*/
      # REPOSITORY_URL = "nginx",
      CLOUDWATCH_GROUP      = aws_cloudwatch_log_group.ecs-cloudwatch-log-group.name,
      #SPRING_DATASOURCE_URL = "jdbc:postgresql://${module.rds.postgres_endpoint}/db_quizzer"
    }
  )
  memory             = 1024 # Specifying the memory our container requires
  cpu                = 256  # Specifying the CPU our container requires
  execution_role_arn = aws_iam_role.quizzer-ecs-instance-role.arn
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quizzer-td"
  })
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"
}
resource "aws_ecs_service" "quizzer-service" {
  name            = "${local.name_prefix}-quizzer-service"
  cluster         = aws_ecs_cluster.quizzer-ecs-cluster.id
  task_definition = aws_ecs_task_definition.quizzer-td.arn
  desired_count   = 2
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quizzer-service"
  })

  load_balancer {
    target_group_arn = aws_lb_target_group.quizzer-tg.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.quizzer-td.family
    container_port   = 8080 # Specifying the container port
  }
  depends_on  = [aws_lb_listener.api-listener, aws_iam_role_policy_attachment.quizzer-ecs-rpa]
  launch_type = "FARGATE"
  network_configuration {
    security_groups = [aws_security_group.quizzer-sg.id]
    subnets = [
      aws_subnet.subnet-1.id,
      aws_subnet.subnet-2.id
    ]
    assign_public_ip = true # Providing our containers with public IPs
  }

}
