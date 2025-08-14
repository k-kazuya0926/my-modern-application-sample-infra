# 推奨コマンド集

## Terraform基本操作

### 初期設定・セットアップ
```bash
# 環境ディレクトリに移動
cd environments/prod

# バックエンド設定でTerraformを初期化
aea terraform init -backend-config=backend.hcl

# 設定を検証
terraform validate

# コードをフォーマット
terraform fmt -recursive
```

### 計画・適用
```bash
# インフラストラクチャの変更を計画
aea terraform plan

# インフラストラクチャの変更を適用
aea terraform apply

# 現在の状態を表示
aea terraform show
```

### インポート・管理
```bash
# 既存リソースをインポート
aea terraform import <resource_type>.<resource_name> <resource_id>

# 状態ファイルの確認
terraform state list
```

## データストア管理（個別状態）
```bash
# DynamoDB設定
cd environments/prod/data_stores/dynamodb
aea terraform init -backend-config=../../backend.hcl
aea terraform plan
aea terraform apply

# RDS設定
cd environments/prod/data_stores/rds
aea terraform init -backend-config=../../backend.hcl
aea terraform plan
aea terraform apply

# VPC設定
cd environments/prod/vpc
aea terraform init -backend-config=../../backend.hcl
aea terraform plan
aea terraform apply
```

## CI/CD・品質チェック

### GitHub Actionsワークフローのリンティング
```bash
docker run --rm -v "$(pwd):$(pwd)" -w "$(pwd)" rhysd/actionlint:latest
```

### セキュリティスキャン（ローカル実行）
```bash
# Trivyによる脆弱性スキャン
trivy fs .
```

## バックエンド設定

### 初回セットアップ
```bash
# バックエンド設定例をコピー
cp environments/backend.hcl.example environments/prod/backend.hcl

# 必要事項を編集（S3バケット名、リージョン）
# bucket = "your-terraform-state-bucket"
# region = "ap-northeast-1"
```

## バージョン確認
```bash
# Terraformバージョン確認
terraform version

# 必要バージョン: 1.12.2
# AWS Provider: 6.0.0
```