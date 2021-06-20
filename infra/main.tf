locals {
  name_prefix = lower(terraform.workspace)
  common_tags = {
    ManagedBy = "terraform"
    Environment = local.name_prefix
  }
}
resource "aws_iam_user" "github-ci" {
  name = "${local.name_prefix}-github-ci"
  tags = local.common_tags
}

resource "aws_iam_access_key" "dev" {
  user = aws_iam_user.github-ci.name
}

resource "aws_iam_policy" "github-ci-access-policy" {
  name        = "${local.name_prefix}-github-ci-access-policy"
  description = "Github CI/CD policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "ecr:*",
        "iam:*",
        "kms:*",
        "logs:*",
        "route53:*",
        "ecs:*",
        "secretsmanager:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

/*module "rds" {
  source = "./rds"
  name_prefix = local.name_prefix
  common_tags = local.common_tags
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  quizzer_sg_id = aws_security_group.quizzer-sg.id
  vpc_id = aws_vpc.vpc.id
}*/

resource "aws_iam_user_policy_attachment" "github-ci-policy-attachment" {
  user       = aws_iam_user.github-ci.name
  policy_arn = aws_iam_policy.github-ci-access-policy.arn
}

output "github_user_role" {
  value = aws_iam_user.github-ci.name
}

output "current_env" {
  value = local.name_prefix
}

//output "postgres_endpoint" {
//  value = module.rds.postgres_endpoint
//}