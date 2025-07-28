# CLAUDE.md

このファイルは、このリポジトリでコードを操作する際のClaude Code (claude.ai/code) へのガイダンスを提供します。

**重要**: コードベースに変更を加える際は、このファイルの内容を適宜更新し、最新の状態を保つようにしてください。

## プロジェクト概要

これは、AWS上でTerraformを使用したモダンなサーバーレスアプリケーションのInfrastructure as Codeリポジトリです。このインフラストラクチャは、イベント駆動通信パターンを持つマイクロサービスアーキテクチャをサポートしています。

## 共通コマンド

### Terraform操作
```bash
# 環境ディレクトリに移動
cd environments/prod

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
```

### バックエンド設定
- `environments/backend.hcl.example`を`environments/prod/backend.hcl`にコピー
- 状態保存用のS3バケット名とリージョンを設定
- 状態ファイルはS3に保存され、DynamoDBロックが有効

## アーキテクチャ

### モジュール構造
- **environments/**: 環境固有の設定（現在は`prod`）
- **modules/**: AWSサービス用の再利用可能なTerraformモジュール
- **environments/prod/data_stores/**: データレイヤー用の個別状態管理

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
- `environments/prod/`のメインインフラストラクチャ
- `environments/prod/data_stores/`で個別に管理されるDynamoDBテーブル
- `terraform_remote_state`を使用したレイヤー間のリモート状態参照

## 開発ワークフロー

### 新しいLambda関数の追加
1. `ecr.tf`でECRリポジトリを作成
2. `lambda.tf`で必要な設定を含むLambdaモジュールを追加：
   - `function_name`: 一意の識別子
   - `image_uri`: ECRリポジトリURL
   - `policy_statements`: 必要なIAM権限
   - `environment_variables`: ランタイム設定
   - オプショントリガー: `s3_trigger_*`または`sqs_trigger_*`

### モジュール開発
- すべてのモジュールは標準構造に従う：`main.tf`、`variables.tf`、`outputs.tf`
- 現在のAWSアカウント/リージョン情報にはデータソースを使用
- 柔軟なIAM権限のための動的ポリシーステートメントを実装
- `count`パラメータによる条件付きリソース作成をサポート

### Terraformバージョン
- Terraform: 1.12.2
- AWSプロバイダー: 6.0.0
- バックエンド: DynamoDBによる状態ロック付きS3

## ファイル構成

### 環境構造
```
environments/prod/
├── data_stores/dynamodb/    # DynamoDB用の個別状態
├── backend.hcl             # バックエンド設定
├── terraform.tfvars        # 環境変数
├── *.tf                    # サービス設定
```

### モジュール構造
```
modules/<service>/
├── main.tf                 # リソース定義
├── variables.tf            # 入力変数
├── outputs.tf              # 出力値
```

## 主要な慣例

- リソース命名: `${var.github_repository_name}-${var.env}-${specific_name}`
- すべてのLambda関数はコンテナパッケージングを使用
- IAMポリシーは柔軟性のために動的ステートメントを使用
- ログ保持期間は設定可能
- X-Rayトレーシングは関数ごとにオプション
- 環境変数はTerraform経由で渡される
- **変数とアウトプットのdescriptionは日本語で記述する**
