module "github_actions_openid_connect_provider" {
  source = "../../modules/github_actions_openid_connect_provider"
}

module "github_actions_role" {
  source                          = "../../modules/github_actions_role"
  iam_openid_connect_provider_arn = module.github_actions_openid_connect_provider.iam_openid_connect_provider_arn
  github_owner_name               = var.github_owner_name
  github_repository_name          = var.github_repository_name
  env                             = local.env
  policy                          = data.aws_iam_policy_document.github_actions.json
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
      "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/${var.github_repository_name}-${local.env}-hello-world",
      "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/${var.github_repository_name}-${local.env}-tmp",
      "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/${var.github_repository_name}-${local.env}-read-and-write-s3",
      "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/${var.github_repository_name}-${local.env}-register-user"
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
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-hello-world",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-hello-world:*",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-tmp",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-tmp:*",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-read-and-write-s3",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-read-and-write-s3:*",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-register-user",
      "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.github_repository_name}-${local.env}-register-user:*"
    ]
  }
}


module "lambda_execution_role_hello_world" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "hello-world"
  policy                 = data.aws_iam_policy_document.lambda_hello_world.json
}

data "aws_iam_policy_document" "lambda_hello_world" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.github_repository_name}-${local.env}-hello-world:*"]
  }
}


module "lambda_execution_role_tmp" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "tmp"
  policy                 = data.aws_iam_policy_document.lambda_tmp.json
}

data "aws_iam_policy_document" "lambda_tmp" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.github_repository_name}-${local.env}-tmp:*"]
  }
}


module "lambda_execution_role_read_and_write_s3" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "read-and-write-s3"
  policy                 = data.aws_iam_policy_document.lambda_read_and_write_s3.json
}

data "aws_iam_policy_document" "lambda_read_and_write_s3" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.github_repository_name}-${local.env}-read-and-write-s3:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.github_repository_name}-${local.env}-read",
      "arn:aws:s3:::${var.github_repository_name}-${local.env}-read/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${var.github_repository_name}-${local.env}-write/*"
    ]
  }
}


module "lambda_execution_role_register_user" {
  source                 = "../../modules/lambda_execution_role"
  github_repository_name = var.github_repository_name
  env                    = local.env
  role_name              = "register-user"
  policy                 = data.aws_iam_policy_document.lambda_register_user.json
}

data "aws_iam_policy_document" "lambda_register_user" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.github_repository_name}-${local.env}-register-user:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:table/${var.github_repository_name}-${local.env}-users",
      "arn:aws:dynamodb:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:table/${var.github_repository_name}-${local.env}-sequences"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.github_repository_name}-${local.env}-contents",
      "arn:aws:s3:::${var.github_repository_name}-${local.env}-contents/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail"
    ]
    resources = [
      "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/*"
    ]
  }
}
