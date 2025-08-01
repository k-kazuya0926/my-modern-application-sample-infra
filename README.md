# my-modern-application-sample-infra

## アプリケーション
https://github.com/k-kazuya0926/my-modern-application-sample

## 技術スタック

### Infrastructure as Code
- **Terraform**: 1.12.2
- **AWS Provider**: 6.0.0

### AWSサービス
- **API Gateway**: RESTful APIエンドポイント、IDトークンの検証
- **AppConfig**: フィーチャーフラグ管理（アプリケーション設定の動的変更）
- **Cognito**: ユーザー認証・認可サービス
- **DynamoDB**: NoSQLデータベース
- **ECR**: Dockerコンテナレジストリ
- **IAM**: アクセス権限管理
- **Lambda**: サーバーレス処理
- **RDS**: Aurora PostgreSQL Serverless v2によるリレーショナルデータベース
- **S3**: オブジェクトストレージ（読み取り用、書き込み用、コンテンツ用、メール本文用）
- **SES**: メール送信サービス
- **SNS**: 通知サービス
- **SQS**: メッセージキューサービス
- **Step Functions**: ワークフロー管理・オーケストレーション
- **X-Ray**: 分散トレーシング

### CI/CD
- **GitHub Actions**: OIDC連携によるセキュアなデプロイメント

## 特長

### モジュール化アーキテクチャ
- 再利用可能なTerraformモジュールによる構成
- 環境ごとの設定分離

### セキュリティ
- IAM最小権限の原則に基づく権限管理
- Lambda実行ロールの関数ごと分離
- GitHub ActionsのOIDC連携によるセキュアなCI/CD

### スケーラビリティ
- サーバーレスアーキテクチャによる自動スケーリング
- マネージドサービスの活用による運用負荷軽減

## ディレクトリ構成

```
environments/          # 環境別設定
├── prod/              # 本番環境
│   ├── data_stores/   # データストア設定
│   │   └── dynamodb/  # DynamoDB設定
│   │   └── rds/       # RDS設定
│   ├── vpc/           # VPC設定
│   ├── api_gateway.tf # API Gateway
│   └── ...
└── backend.hcl.example # バックエンド設定例

modules/               # 再利用可能モジュール
├── api_gateway_http/  # API Gateway HTTP API
├── appconfig/         # AppConfig
└── ...
```

## 参考図書

- 実践Terraform AWSにおけるシステム設計とベストプラクティス
- 詳解 Terraform 第3版 ―Infrastructure as Codeを実現する
- GitHub CI/CD実践ガイド――持続可能なソフトウェア開発を支えるGitHub Actionsの設計と運用
- AWS Lambda実践ガイド 第2版
- AWSで実現するモダンアプリケーション入門 〜サーバーレス、コンテナ、マイクロサービスで何ができるのか
- 雰囲気でOAuth2.0を使っているエンジニアがOAuth2.0を整理して、手を動かしながら学べる本
- OAuth、OAuth認証、OpenID Connectの違いを整理して理解できる本
- OAuth・OIDCへの攻撃と対策を整理して理解できる本(リダイレクトへの攻撃編)
- AWSクラウドネイティブデザインパターン
- 基礎から学ぶ サーバーレス開発
