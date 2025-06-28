data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "lambda_execution_role_hello_world" {
  source       = "../../modules/lambda_execution_role"
  project_name = var.project_name
  env          = var.env
  role_name    = "hello-world"
}

module "lambda_execution_role_tmp" {
  source       = "../../modules/lambda_execution_role"
  project_name = var.project_name
  env          = var.env
  role_name    = "tmp"
}

module "github_actions_openid_connect_provider" {
  source            = "../../modules/github_actions_openid_connect_provider"
  github_owner_name = var.github_owner_name
  project_name      = var.project_name
  env               = var.env
  policy            = data.aws_iam_policy_document.github_actions.json
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    sid    = "ECRPermissions"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ECRRepositoryPermissions"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [
      "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-${var.env}-hello-world",
      "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-${var.env}-tmp"
    ]
  }

  statement {
    sid    = "LambdaDeployPermissions"
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:PublishVersion",
      "lambda:UpdateAlias"
    ]
    resources = [
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.project_name}-${var.env}-hello-world",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.project_name}-${var.env}-hello-world:*",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.project_name}-${var.env}-tmp",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.project_name}-${var.env}-tmp:*"
    ]
  }
}
