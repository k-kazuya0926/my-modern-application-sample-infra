# コードベース構造

## ディレクトリ構成

```
my-modern-application-sample-infra/
├── environments/                    # 環境別設定
│   ├── backend.hcl.example         # バックエンド設定例
│   └── prod/                       # 本番環境設定
│       ├── data_stores/            # データストア用個別状態管理
│       │   ├── dynamodb/           # DynamoDB設定
│       │   └── rds/                # RDS Aurora設定
│       ├── vpc/                    # VPC設定（個別状態）
│       ├── *.tf                    # 各AWSサービス設定
│       ├── terraform.tfvars.example # 環境変数例
│       └── backend.hcl             # バックエンド設定（実際のファイル）
├── modules/                        # 再利用可能Terraformモジュール
│   ├── api_gateway_http/           # HTTP API Gateway
│   ├── appconfig/                  # AppConfig（フィーチャーフラグ）
│   ├── aurora_serverless_v2/       # Aurora Serverless v2
│   ├── cognito_user_pool/          # Cognito認証
│   ├── dynamodb/                   # DynamoDB
│   ├── ecr/                        # Elastic Container Registry
│   ├── ecs_cluster/                # ECS Cluster
│   ├── ecs_service/                # ECS Service
│   ├── github_actions_*            # GitHub Actions OIDC設定
│   ├── lambda/                     # Lambda関数
│   ├── s3/                         # S3バケット
│   ├── ses/                        # Simple Email Service
│   ├── sns/                        # Simple Notification Service
│   ├── sqs/                        # Simple Queue Service
│   ├── step_functions/             # Step Functions
│   └── vpc/                        # Virtual Private Cloud
├── .github/                        # GitHub設定
│   ├── workflows/                  # CI/CDワークフロー
│   │   ├── static-analysis.yml     # GitHub Actionsリンティング
│   │   └── security-scan.yml       # Trivyセキュリティスキャン
│   ├── CODEOWNERS                  # コードオーナー設定
│   └── dependabot.yml              # 依存関係自動更新
├── CLAUDE.md                       # プロジェクト指針
├── README.md                       # プロジェクト概要
└── .terraform-version              # Terraformバージョン固定
```

## 主要設定ファイル

### 環境設定
- `environments/prod/terraform.tf`: プロバイダー・バックエンド設定
- `environments/prod/variables.tf`: 環境変数定義
- `environments/prod/locals.tf`: ローカル値定義

### サービス設定
- `lambda.tf`: Lambda関数定義
- `ecr.tf`: ECRリポジトリ定義
- `s3.tf`: S3バケット定義
- `api_gateway.tf`: API Gateway設定
- `sqs.tf`, `sns.tf`: メッセージング設定

### モジュール構造（標準）
各モジュールは以下の構成：
- `main.tf`: リソース定義
- `variables.tf`: 入力変数
- `outputs.tf`: 出力値

## 状態管理パターン

### メインインフラ状態
- 場所: `environments/prod/`
- 内容: Lambda、API Gateway、S3、SQS、SNSなど

### 個別状態管理
- **DynamoDB**: `environments/prod/data_stores/dynamodb/`
- **RDS**: `environments/prod/data_stores/rds/`
- **VPC**: `environments/prod/vpc/`

### 状態参照
`terraform_remote_state`データソースで他の状態を参照