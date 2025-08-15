# 推奨コマンド

## 必須ツール
- **aws-vault**: AWSクレデンシャル管理（`aea`としてエイリアス設定済み）
- **terraform**: 1.12.2
- **git**: バージョン管理

## AWS Terraform操作

### 基本的なワークフロー
```bash
# AWS環境ディレクトリに移動
cd aws/environments/prod

# バックエンド設定でTerraformを初期化
aea terraform init -backend-config=backend.hcl

# インフラストラクチャの変更を計画
aea terraform plan

# インフラストラクチャの変更を適用
aea terraform apply
```

### 設定とメンテナンス
```bash
# 設定を検証
terraform validate

# コードをフォーマット
terraform fmt -recursive

# 現在の状態を表示
aea terraform show

# 既存リソースをインポート
aea terraform import <resource_type>.<resource_name> <resource_id>
```

### データストア個別管理
```bash
# DynamoDB管理
cd aws/environments/prod/data_stores/dynamodb
aea terraform init -backend-config=../backend.hcl && aea terraform plan && aea terraform apply

# RDS管理
cd aws/environments/prod/data_stores/rds
aea terraform init -backend-config=../backend.hcl && aea terraform plan && aea terraform apply

# VPC管理
cd aws/environments/prod/vpc
aea terraform init -backend-config=../backend.hcl && aea terraform plan && aea terraform apply
```

## Google Cloud Terraform操作

```bash
# Google Cloud環境に移動
cd google/environments/prod

# 初期化と適用
terraform init
terraform plan
terraform apply
```

## 初期設定

### AWSバックエンド設定
```bash
# バックエンド設定ファイルをコピー
cp aws/environments/backend.hcl.example aws/environments/prod/backend.hcl

# backend.hclでS3バケット名とリージョンを設定
# bucket = "your-terraform-state-bucket"
# region = "ap-northeast-1"
```

### 変数設定
```bash
# 変数ファイルをコピー
cp aws/environments/prod/terraform.tfvars.example aws/environments/prod/terraform.tfvars

# terraform.tfvarsで以下を設定:
# - github_owner_name
# - github_repository_name  
# - ses_email_addresses
# - mail_from
```

## 一般的なワークフロー

### 新しいLambda関数追加時
1. `aws/environments/prod/ecr.tf`でECRリポジトリを作成
2. `aws/environments/prod/lambda.tf`でLambdaモジュールを追加
3. `terraform plan`で確認後、`terraform apply`で適用

### トラブルシューティング
```bash
# 状態ファイルの確認
aea terraform state list

# 特定リソースの状態確認
aea terraform state show <resource_name>

# 状態のリフレッシュ
aea terraform refresh
```