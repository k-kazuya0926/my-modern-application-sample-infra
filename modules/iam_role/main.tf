resource "aws_iam_role" "this" {
  name               = "${var.project_name}-${var.env}-${var.role_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.project_name}-${var.env}-${var.role_name}"
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
