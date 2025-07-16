module "step_functions_saga_orchestration" {
  source                 = "../../modules/step_functions"
  github_repository_name = var.github_repository_name
  env                    = local.env
  state_machine_name     = "saga-orchestration"
  type                   = "STANDARD"
  enable_xray_tracing    = true

  definition = jsonencode({
    Comment = "Saga pattern orchestration for payment processing"
    StartAt = "ProcessPayment"
    States = {
      ProcessPayment = {
        Type     = "Task"
        Resource = module.lambda_process_payment.function_arn
        Retry = [
          {
            ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException", "Lambda.SdkClientException"]
            IntervalSeconds = 2
            MaxAttempts     = 3
            BackoffRate     = 2.0
          }
        ]
        Catch = [
          {
            ErrorEquals = ["States.ALL"]
            Next        = "Failed"
          }
        ]
        Next = "CreatePurchaseHistory"
      }

      CreatePurchaseHistory = {
        Type     = "Task"
        Resource = module.lambda_create_purchase_history.function_arn
        Retry = [
          {
            ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException", "Lambda.SdkClientException"]
            IntervalSeconds = 2
            MaxAttempts     = 3
            BackoffRate     = 2.0
          }
        ]
        Catch = [
          {
            ErrorEquals = ["States.ALL"]
            Next        = "CancelPayment"
          }
        ]
        Next = "AwardPoints"
      }

      AwardPoints = {
        Type     = "Task"
        Resource = module.lambda_award_points.function_arn
        Retry = [
          {
            ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException", "Lambda.SdkClientException"]
            IntervalSeconds = 2
            MaxAttempts     = 3
            BackoffRate     = 2.0
          }
        ]
        Catch = [
          {
            ErrorEquals = ["States.ALL"]
            Next        = "DeletePurchaseHistory"
          }
        ]
        Next = "Success"
      }

      # 補償トランザクション（Compensation Transactions）
      CancelPayment = {
        Type     = "Task"
        Resource = module.lambda_cancel_payment.function_arn
        Retry = [
          {
            ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException", "Lambda.SdkClientException"]
            IntervalSeconds = 2
            MaxAttempts     = 3
            BackoffRate     = 2.0
          }
        ]
        Next = "Failed"
      }

      DeletePurchaseHistory = {
        Type     = "Task"
        Resource = module.lambda_delete_purchase_history.function_arn
        Retry = [
          {
            ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException", "Lambda.SdkClientException"]
            IntervalSeconds = 2
            MaxAttempts     = 3
            BackoffRate     = 2.0
          }
        ]
        Next = "CancelPayment"
      }

      Failed = {
        Type  = "Fail"
        Error = "SagaTransactionFailed"
        Cause = "Saga transaction failed and appropriate compensation actions have been executed"
      }

      Success = {
        Type = "Succeed"
      }
    }
  })

  custom_policy_statements = [
    {
      effect = "Allow"
      actions = [
        "lambda:InvokeFunction"
      ]
      resources = [
        module.lambda_process_payment.function_arn,
        module.lambda_create_purchase_history.function_arn,
        module.lambda_award_points.function_arn,
        module.lambda_cancel_payment.function_arn,
        module.lambda_delete_purchase_history.function_arn,
        module.lambda_cancel_points.function_arn
      ]
    }
  ]

  tags = {
    Purpose = "Saga orchestration for payment processing"
  }
}
