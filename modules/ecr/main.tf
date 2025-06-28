resource "aws_ecr_repository" "this" {
  name                 = "${var.github_repository_name}-${var.env}-${var.ecr_repository_name}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
