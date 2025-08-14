# プロジェクトの目的

このプロジェクトは、AWSクラウド上にサーバーレスマイクロサービスアーキテクチャを構築するためのTerraform Infrastructure as Codeリポジトリです。

## 主な特徴

- **モダンサーバーレスアーキテクチャ**: Lambda、API Gateway、DynamoDB、S3などのAWSマネージドサービスを活用
- **マイクロサービス設計**: 各機能が独立したLambda関数として実装
- **Infrastructure as Code**: Terraformによる宣言的なインフラ管理
- **セキュリティファースト**: IAM最小権限の原則、個別実行ロール、OIDC認証
- **CI/CD統合**: GitHub ActionsによるOIDC連携でのセキュアなデプロイメント

## 対象アプリケーション

このインフラは以下のアプリケーションをサポートします：
- **Go言語ベースのLambda関数**: https://github.com/k-kazuya0926/my-modern-application-sample
- **コンテナベースのサーバーレス処理**: ECRからのコンテナイメージ使用

## アーキテクチャパターン

- イベント駆動通信（SQS/SNS）
- Sagaパターンによる分散トランザクション（Step Functions）
- 複数データストレージパターン（DynamoDB、Aurora Serverless v2）
- フィーチャーフラグ管理（AppConfig）
- 認証・認可統合（Cognito）