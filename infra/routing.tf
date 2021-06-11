
# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rtb"
  })
}

resource "aws_route_table_association" "rta-subnet-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rta-subnet-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #
resource "aws_security_group" "elb-sg" {
  name   = "${local.name_prefix}-elb-sg"
  vpc_id = aws_vpc.vpc.id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Nginx security group 
resource "aws_security_group" "quizzer-sg" {
  name   = "${local.name_prefix}-quizzer-sg"
  vpc_id = aws_vpc.vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.elb-sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}


# LOAD BALANCER #
resource "aws_lb" "api-lb" {
  name               = "${local.name_prefix}-api-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  security_groups    = [aws_security_group.elb-sg.id]
  tags = local.common_tags
}
resource "aws_lb_target_group" "quizzer-tg" {
  name        = "${local.name_prefix}-quizzer-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id # Referencing the default VPC
  target_type = "ip"
  slow_start  = 120

  health_check {
    interval            = 60
    path                = "/actuator/health"
    timeout             = 30
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = local.common_tags
}
data "aws_acm_certificate" "quizzer_domain" {
  domain      = "modaista.in"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
data "aws_route53_zone" "domain_zone" {
  name = "modaista.in"
}
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = "${local.name_prefix}-api.modaista.in"
  type    = "A"

  alias {
    name                   = aws_lb.api-lb.dns_name
    zone_id                = aws_lb.api-lb.zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_lb.api-lb]
}
resource "aws_lb_listener" "api-listener" {
  load_balancer_arn = aws_lb.api-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn =  data.aws_acm_certificate.quizzer_domain.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quizzer-tg.arn
  }
  /* default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No accessible service at path"
      status_code  = "404"
    }
  } */
}
/* resource "aws_lb_listener_rule" "menu-service-listener-rule" {
  listener_arn = aws_lb_listener.api-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.menu-tg.arn
  }

  condition {
    path_pattern {
      values = ["/menu", "/menu/*"]
    }
  }

  condition {
    host_header {
      values = [aws_route53_record.api.name]
    }
  }
} */
resource "aws_lb_listener" "http-api-listener" {
  load_balancer_arn = aws_lb.api-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
output "aws_elb_public_dns" {
  value = aws_lb.api-lb.dns_name
}
