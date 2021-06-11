
resource "aws_ecr_repository" "quizzer-ecr-repo" {
  name                 = "${local.name_prefix}-quizzer-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = merge(local.common_tags, {
    Name = "ecr"
  })
}
