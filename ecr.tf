# Preprerequisite for any App deployment. Create ECR repository

resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = var.appname
  image_tag_mutability = "MUTABLE"  # or "IMMUTABLE" based on your requirement
  image_scanning_configuration {
    scan_on_push = true
  }
}