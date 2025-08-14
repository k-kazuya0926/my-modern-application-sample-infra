# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**重要**: コードベースに変更を加える際は、このファイルの内容を適宜更新し、最新の状態を保つようにしてください。

## プロジェクト概要

これは、AWSとGoogle Cloudの両方でTerraformを使用したマルチクラウドInfrastructure as Codeリポジトリです。主にAWS上でモダンなサーバーレスアプリケーションのインフラストラクチャを構築し、イベント駆動通信パターンを持つマイクロサービスアーキテクチャをサポートしています。Google Cloudには基本的な設定が含まれています。

## 共通コマンド

### AWS Terraform操作
```bash
# AWS環境ディレクトリに移動
cd aws/environments/prod

# バックエンド設定でTerraformを初期化
aea terraform init -backend-config=backend.hcl

# インフラストラクチャの変更を計画
aea terraform plan

# インフラストラクチャの変更を適用
aea terraform apply

# 設定を検証
terraform validate

# コードをフォーマット
terraform fmt -recursive

# 現在の状態を表示
aea terraform show

# 既存リソースをインポート
aea terraform import <resource_type>.<resource_name> <resource_id>

# データストア個別管理（DynamoDB）
cd aws/environments/prod/data_stores/dynamodb
aea terraform init -backend-config=../backend.hcl && aea terraform plan && aea terraform apply

# データストア個別管理（RDS）
cd aws/environments/prod/data_stores/rds
aea terraform init -backend-config=../backend.hcl && aea terraform plan && aea terraform apply

# VPC個別管理
cd aws/environments/prod/vpc
aea terraform init -backend-config=../backend.hcl && aea terraform plan && aea terraform apply
```

### Google Cloud Terraform操作
```bash
# Google Cloud環境に移動
cd google_cloud/basic

# 初期化と適用
terraform init
terraform plan
terraform apply
```

### バックエンド設定
- `aws/environments/backend.hcl.example`を`aws/environments/prod/backend.hcl`にコピー
- 状態保存用のS3バケット名とリージョンを設定
- 状態ファイルはS3に保存され、DynamoDBロックが有効

## アーキテクチャ

### ディレクトリ構造
- **aws/**: AWSインフラストラクチャ
  - **environments/prod/**: 本番環境設定
  - **environments/prod/data_stores/**: データレイヤー用の個別状態管理（DynamoDB、RDS）
  - **environments/prod/vpc/**: VPC設定の個別状態管理
  - **modules/**: AWSサービス用の再利用可能なTerraformモジュール
- **google_cloud/**: Google Cloudインフラストラクチャ
  - **basic/**: 基本的なGoogle Cloudリソース（Compute Engineインスタンス）

### 主要AWSサービス
- **Lambda**: 個別のIAMロールを持つコンテナベース関数
- **API Gateway**: 認証用Cognito統合のHTTP API
- **Step Functions**: X-Rayトレーシングによるワークフロー調整
- **DynamoDB**: 個別状態管理のNoSQLデータベース
- **S3**: 異なる目的のための複数バケット（read、write、contents、mail）
- **SQS/SNS**: メッセージキューイングとファンアウトパターン
- **ECR**: Lambda関数用コンテナレジストリ
- **Cognito**: ユーザー認証と認可
- **AppConfig**: フィーチャーフラグ管理
- **SES**: バウンス処理付きメールサービス
- **Aurora Serverless v2**: 自動スケーリング対応のリレーショナルデータベース

### Lambdaアーキテクチャパターン
各Lambda関数は以下を持ちます：
- 最小権限によるIAM実行ロール
- ECRからのコンテナイメージ使用（ZIPファイルではない）
- 専用のCloudWatchログループ
- `policy_statements`変数によるカスタムポリシーステートメントのサポート
- S3またはSQSトリガーの設定可能
- オプションでX-Rayトレーシングを有効化

### セキュリティパターン
- Lambda関数ごとの個別IAMロール（共有ロールではない）
- 特定のポリシーステートメントによる最小権限の原則
- セキュアなCI/CDのためのGitHub Actions OIDC統合
- 設定のための環境変数注入

### 状態管理
- `aws/environments/prod/`のメインインフラストラクチャ
- `aws/environments/prod/data_stores/dynamodb/`で個別に管理されるDynamoDBテーブル
- `aws/environments/prod/data_stores/rds/`で個別に管理されるAurora PostgreSQL
- `aws/environments/prod/vpc/`で個別に管理されるVPCリソース
- `terraform_remote_state`を使用したレイヤー間のリモート状態参照
- Google Cloudは`google_cloud/basic/`でローカル状態管理

## 開発ワークフロー

### 新しいLambda関数の追加
1. `aws/environments/prod/ecr.tf`でECRリポジトリを作成
2. `aws/environments/prod/lambda.tf`で必要な設定を含むLambdaモジュールを追加：
   - `function_name`: 一意の識別子
   - `image_uri`: ECRリポジトリURL
   - `policy_statements`: 必要なIAM権限
   - `environment_variables`: ランタイム設定
   - オプショントリガー: `s3_trigger_*`または`sqs_trigger_*`

### モジュール開発
- すべてのAWSモジュールは標準構造に従う：`main.tf`、`variables.tf`、`outputs.tf`
- 現在のAWSアカウント/リージョン情報にはデータソースを使用
- 柔軟なIAM権限のための動的ポリシーステートメントを実装
- `count`パラメータによる条件付きリソース作成をサポート

### Google Cloudリソースの追加
1. `google_cloud/basic/main.tf`でリソースを定義
2. 必要に応じて`variables.tf`で変数を定義
3. プロジェクトIDとリージョン（asia-northeast1）を設定
4. 現在はCompute Engineインスタンスの基本設定のみ実装

### Terraformバージョン
- Terraform: 1.12.2
- AWSプロバイダー: 6.0.0
- Google Cloudプロバイダー: 6.48.0
- バックエンド: AWSではDynamoDBによる状態ロック付きS3、Google Cloudではローカル状態

## ファイル構成

### AWS環境構造
```
aws/environments/prod/
├── data_stores/dynamodb/    # DynamoDB用の個別状態
├── data_stores/rds/         # RDS用の個別状態
├── vpc/                     # VPC用の個別状態
├── backend.hcl             # バックエンド設定
├── terraform.tfvars        # 環境変数
├── *.tf                    # サービス設定
```

### AWSモジュール構造
```
aws/modules/<service>/
├── main.tf                 # リソース定義
├── variables.tf            # 入力変数
├── outputs.tf              # 出力値
```

### Google Cloud構造
```
google_cloud/basic/
├── main.tf                 # リソース定義
├── variables.tf            # 入力変数
├── .terraform.lock.hcl     # プロバイダーロック
```

## 主要な慣例

### AWS
- リソース命名: `${var.github_repository_name}-${var.env}-${specific_name}`
- すべてのLambda関数はコンテナパッケージングを使用
- IAMポリシーは柔軟性のために動的ステートメントを使用
- ログ保持期間は設定可能
- X-Rayトレーシングは関数ごとにオプション
- 環境変数はTerraform経由で渡される
- リージョン: ap-northeast-1（東京）
- **変数とアウトプットのdescriptionは日本語で記述する**

### Google Cloud
- リージョン: asia-northeast1（東京）
- プロジェクトIDは変数で管理
- 現在は基本的なCompute Engineインスタンス構成
- ローカル状態管理を使用
