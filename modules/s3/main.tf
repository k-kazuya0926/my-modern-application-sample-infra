resource "aws_s3_bucket" "this" {
  bucket        = "${var.github_repository_name}-${var.env}-${var.bucket_name}"
  force_destroy = var.force_destroy

  lifecycle {
    prevent_destroy = true
  }
}
