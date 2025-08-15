# コードスタイルと規約

## Terraform規約

### ファイル構成
- **variables.tf**: 入力変数定義
- **main.tf**: リソース定義
- **outputs.tf**: 出力値定義
- **terraform.tf**: プロバイダーとバックエンド設定
- **locals.tf**: ローカル値定義

### 変数とアウトプット
- **重要**: すべての変数とアウトプットのdescriptionは**日本語**で記述する
- 例: `description = "Lambda関数の名前"`
- 型指定を必須とする（string, number, bool, list, map, object）

### 命名規則

#### AWSリソース命名
```hcl
name = "${var.github_repository_name}-${var.env}-${specific_name}"
```
- 例: `my-app-prod-lambda-hello-world`

#### 変数命名
- スネークケースを使用: `github_repository_name`, `function_name`
- 論理的なグループ化: `s3_trigger_*`, `sqs_trigger_*`

#### モジュール命名
- プレフィックス付き: `module "lambda_hello_world"`
- サービス名を含む: `module "ecr_hello_world"`

### リソース設定パターン

#### Lambdaモジュール
```hcl
module "lambda_function_name" {
  source                 = "../../modules/lambda"
  github_repository_name = var.github_repository_name
  env                    = local.env
  function_name          = "specific-function-name"
  image_uri              = "${module.ecr_repository.repository_url}:dummy"

  # オプション設定
  memory_size            = 256
  timeout               = 30
  enable_tracing        = true

  # 環境変数
  environment_variables = {
    ENV = local.env
  }

  # IAM権限
  policy_statements = [
    {
      effect    = "Allow"
      actions   = ["dynamodb:GetItem"]
      resources = ["arn:aws:dynamodb:*"]
    }
  ]
}
```

#### 変数定義パターン
```hcl
variable "function_name" {
  description = "Lambda関数の名前"
  type        = string
}

variable "memory_size" {
  description = "Lambda関数のメモリサイズ（MB）"
  type        = number
  default     = 128
}

variable "policy_statements" {
  description = "Lambda実行ロールに追加するIAMポリシーステートメント"
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}
```

## ディレクトリ構造規約

### AWS環境構造
```
aws/environments/prod/
├── data_stores/
│   ├── dynamodb/     # DynamoDB専用状態
│   └── rds/          # RDS専用状態
├── vpc/              # VPC専用状態
├── backend.hcl       # バックエンド設定
├── terraform.tfvars  # 環境変数
└── *.tf              # サービス別設定
```

### モジュール構造
```
aws/modules/<service>/
├── main.tf           # リソース定義
├── variables.tf      # 入力変数
└── outputs.tf        # 出力値
```

## セキュリティ規約

### IAM権限
- 最小権限の原則を適用
- Lambda関数ごとに個別のIAM実行ロールを作成
- 動的ポリシーステートメントを使用して柔軟性を確保

### 機密情報管理
- `.tfvars`ファイルはgitignoreに含める
- `backend.hcl`ファイルはgitignoreに含める
- 環境変数でセンシティブ情報を渡す

## Google Cloud規約

### リージョン設定
- デフォルトリージョン: `asia-northeast1`（東京）
- ゾーン: `asia-northeast1-a`

### プロジェクト設定
- プロジェクトIDは変数で管理
- GCS状態管理を使用

## バージョン管理

### Terraform
- バージョン: 1.12.2（`.terraform-version`で管理）
- プロバイダーロックファイル（`.terraform.lock.hcl`）をコミット

### Git管理対象外
- `.terraform/` ディレクトリ
- `*.tfstate` ファイル
- `*.tfvars` ファイル
- `backend.hcl` ファイル
