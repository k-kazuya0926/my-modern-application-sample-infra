resource "aws_s3_bucket" "this" {
  bucket = "${var.github_repository_name}-${var.env}-${var.bucket_name}"
}
