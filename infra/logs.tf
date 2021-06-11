resource "aws_cloudwatch_log_group" "ecs-cloudwatch-log-group" {
  name = "${local.name_prefix}-ecs-cloudwatch-log-group"
  retention_in_days = 1

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ecs-cloudwatch-log-group"
  })
}