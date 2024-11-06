resource "aws_ecr_repository" "repository_docker" {
  name = var.ecr_name
}