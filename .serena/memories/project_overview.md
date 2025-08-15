# プロジェクト概要

## プロジェクトの目的
このプロジェクトは、AWSとGoogle Cloudの両方でTerraformを使用したマルチクラウドInfrastructure as Codeリポジトリです。主にAWS上でモダンなサーバーレスアプリケーションのインフラストラクチャを構築し、イベント駆動通信パターンを持つマイクロサービスアーキテクチャをサポートしています。

## 技術スタック

### Infrastructure as Code
- **Terraform**: 1.12.2
- **AWS Provider**: 6.0.0
- **Google Cloud Provider**: 6.48.0

### AWSサービス
- **Lambda**: コンテナベースサーバーレス処理（17の関数が定義済み）
- **API Gateway**: RESTful APIエンドポイント、IDトークンの検証
- **DynamoDB**: NoSQLデータベース
- **RDS**: Aurora PostgreSQL Serverless v2
- **S3**: オブジェクトストレージ（読み取り用、書き込み用、コンテンツ用、メール本文用）
- **SQS/SNS**: メッセージキューイングとファンアウトパターン
- **Step Functions**: ワークフロー管理・オーケストレーション
- **ECR**: Dockerコンテナレジストリ
- **Cognito**: ユーザー認証・認可サービス
- **AppConfig**: フィーチャーフラグ管理
- **SES**: メール送信サービス
- **X-Ray**: 分散トレーシング

### Google Cloud
- **Compute Engine**: 基本的なインスタンス設定（asia-northeast1リージョン）

### CI/CD
- **GitHub Actions**: OIDC連携によるセキュアなデプロイメント

## アーキテクチャの特徴

### モジュール化アーキテクチャ
- 再利用可能なTerraformモジュールによる構成
- 環境ごとの設定分離
- AWS: 17種類のモジュール（lambda, s3, api_gateway_http, etc.）

### セキュリティ
- IAM最小権限の原則に基づく権限管理
- Lambda実行ロールの関数ごと分離
- GitHub ActionsのOIDC連携によるセキュアなCI/CD

### スケーラビリティ
- サーバーレスアーキテクチャによる自動スケーリング
- マネージドサービスの活用による運用負荷軽減

### 状態管理
- AWS: S3バックエンド + DynamoDBロック
- 個別状態管理（data_stores/dynamodb, data_stores/rds, vpc）
- Google Cloud: GCSバックエンド
