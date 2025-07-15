# シンプルなHello Worldワークフロー
module "step_functions_hello_world" {
  source = "../../modules/step_functions"

  github_repository_name = var.github_repository_name
  env                    = local.env
  state_machine_name     = "hello-step-functions"

  definition = jsonencode({
    Comment = "A Hello World example"
    StartAt = "HelloWorld"
    States = {
      HelloWorld = {
        Type   = "Pass"
        Result = "Hello World!"
        End    = true
      }
    }
  })

  type                   = "STANDARD"
  include_execution_data = true
  log_level              = "ALL"
  log_retention_in_days  = 14

  tags = {
    Environment = local.env
    Project     = var.github_repository_name
    Purpose     = "Step Functions Hello World Sample"
  }
}

# Lambda関数を呼び出すワークフロー（既存のhello-world Lambda関数を想定）
module "step_functions_lambda_invoke" {
  source = "../../modules/step_functions"

  github_repository_name = var.github_repository_name
  env                    = local.env
  state_machine_name     = "lambda-invoke"

  definition = jsonencode({
    Comment = "A simple workflow that invokes a Lambda function"
    StartAt = "InvokeLambda"
    States = {
      InvokeLambda = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = module.lambda_hello_world.function_name
          Payload = {
            "message" = "Hello from Step Functions!"
          }
        }
        ResultPath = "$.lambda_result"
        Next       = "ProcessResult"
      }
      ProcessResult = {
        Type = "Pass"
        Result = {
          status  = "success"
          message = "Lambda function executed successfully"
        }
        End = true
      }
    }
  })

  type                   = "STANDARD"
  include_execution_data = true
  log_level              = "ALL"
  log_retention_in_days  = 14

  # Lambda関数を呼び出すための追加権限
  custom_policy_statements = [
    {
      effect = "Allow"
      actions = [
        "lambda:InvokeFunction"
      ]
      resources = [
        module.lambda_hello_world.function_arn
      ]
    }
  ]

  tags = {
    Environment = local.env
    Project     = var.github_repository_name
    Purpose     = "Step Functions Lambda Invoke Sample"
  }
}

# 並列実行のワークフロー
module "step_functions_parallel" {
  source = "../../modules/step_functions"

  github_repository_name = var.github_repository_name
  env                    = local.env
  state_machine_name     = "parallel-execution"

  definition = jsonencode({
    Comment = "A simple workflow with parallel execution"
    StartAt = "ParallelExecution"
    States = {
      ParallelExecution = {
        Type = "Parallel"
        Branches = [
          {
            StartAt = "Task1"
            States = {
              Task1 = {
                Type   = "Pass"
                Result = "Task 1 completed"
                End    = true
              }
            }
          },
          {
            StartAt = "Task2"
            States = {
              Task2 = {
                Type   = "Pass"
                Result = "Task 2 completed"
                End    = true
              }
            }
          }
        ]
        Next = "FinalTask"
      }
      FinalTask = {
        Type   = "Pass"
        Result = "All parallel tasks completed"
        End    = true
      }
    }
  })

  type                   = "STANDARD"
  include_execution_data = true
  log_level              = "ALL"
  log_retention_in_days  = 14

  tags = {
    Environment = local.env
    Project     = var.github_repository_name
    Purpose     = "Step Functions Parallel Execution Sample"
  }
}
