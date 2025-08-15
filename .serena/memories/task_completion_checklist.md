# タスク完了時のチェックリスト

## 必須実行コマンド

### 1. コード検証とフォーマット
```bash
# Terraformファイルの構文検証
terraform validate

# コードの自動フォーマット
terraform fmt -recursive
```

### 2. 計画と確認
```bash
# 変更内容の事前確認
aea terraform plan

# 計画内容をレビューして意図した変更か確認
```

### 3. 適用前チェック
- [ ] `.tfvars`ファイルが正しく設定されているか
- [ ] `backend.hcl`ファイルが正しく設定されているか  
- [ ] IAM権限が最小権限の原則に従っているか
- [ ] セキュリティグループの設定が適切か
- [ ] 環境変数が正しく設定されているか

### 4. 適用
```bash
# インフラストラクチャの変更を適用
aea terraform apply
```

### 5. 適用後確認
```bash
# 状態の確認
aea terraform show

# リソースの状態確認
aea terraform state list
```

## 環境別チェックリスト

### AWS環境
- [ ] `aws/environments/prod/`で作業しているか
- [ ] `aea`コマンドを使用してAWSクレデンシャルが正しく設定されているか
- [ ] S3バックエンドが正しく初期化されているか
- [ ] DynamoDBロックが有効になっているか

### データストア個別管理の場合
```bash
# DynamoDB変更時
cd aws/environments/prod/data_stores/dynamodb
aea terraform init -backend-config=../backend.hcl
aea terraform plan
aea terraform apply

# RDS変更時  
cd aws/environments/prod/data_stores/rds
aea terraform init -backend-config=../backend.hcl
aea terraform plan
aea terraform apply

# VPC変更時
cd aws/environments/prod/vpc
aea terraform init -backend-config=../backend.hcl
aea terraform plan
aea terraform apply
```

### Google Cloud環境
- [ ] `google/environments/prod/`で作業しているか
- [ ] Google Cloudクレデンシャルが正しく設定されているか
- [ ] プロジェクトIDが正しく設定されているか

## コードレビューチェックリスト

### 変数定義
- [ ] すべての変数にdescriptionが日本語で記述されているか
- [ ] 型指定が適切に行われているか
- [ ] デフォルト値が適切に設定されているか
- [ ] バリデーションルールが必要な場合は設定されているか

### リソース設定
- [ ] 命名規則に従っているか（`${var.github_repository_name}-${var.env}-${specific_name}`）
- [ ] タグ設定が適切に行われているか
- [ ] セキュリティ設定が適切か

### モジュール使用
- [ ] 適切なモジュールが選択されているか
- [ ] 必要なパラメータが正しく渡されているか
- [ ] 出力値が適切に定義されているか

## トラブルシューティング時の確認項目

### 初期化エラー
- [ ] `backend.hcl`ファイルが存在し、正しく設定されているか
- [ ] S3バケットが存在し、アクセス権限があるか
- [ ] DynamoDBテーブルが存在し、アクセス権限があるか

### プラン/適用エラー
- [ ] AWSクレデンシャルが正しく設定されているか
- [ ] 必要なIAM権限があるか
- [ ] リソースの依存関係が正しく設定されているか
- [ ] 既存リソースとの競合がないか

### 状態管理エラー
- [ ] 状態ファイルが破損していないか
- [ ] ロックファイルが残っていないか
- [ ] 複数人での同時作業による競合がないか

## ドキュメント更新

### CLAUDE.md更新
- [ ] 新しいモジュールや設定を追加した場合、CLAUDE.mdを更新したか
- [ ] コマンドや手順に変更があった場合、ドキュメントを更新したか

### README.md更新
- [ ] アーキテクチャに変更があった場合、README.mdを更新したか
- [ ] 新しいAWSサービスを追加した場合、技術スタックを更新したか