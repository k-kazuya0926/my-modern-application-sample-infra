# 技術スタック

## Infrastructure as Code
- **Terraform**: 1.12.2（バージョン固定）
- **AWS Provider**: 6.0.0（バージョン固定）
- **Backend**: S3 + DynamoDBロック

## AWSサービス
- **API Gateway**: HTTP API、Cognito統合認証
- **Lambda**: コンテナベース関数（ECRからデプロイ）
- **ECR**: Dockerコンテナレジストリ
- **DynamoDB**: NoSQLデータベース（個別状態管理）
- **Aurora Serverless v2**: PostgreSQLリレーショナルデータベース
- **S3**: オブジェクトストレージ（読み取り、書き込み、コンテンツ、メール用）
- **SQS/SNS**: メッセージキューイング、ファンアウトパターン
- **Step Functions**: ワークフローオーケストレーション、X-Rayトレーシング
- **SES**: メール送信、バウンス処理
- **Cognito**: ユーザー認証・認可
- **AppConfig**: フィーチャーフラグ管理
- **IAM**: 最小権限アクセス管理
- **X-Ray**: 分散トレーシング

## CI/CD
- **GitHub Actions**: OIDC連携によるセキュアなデプロイメント
- **アクションリント**: rhysd/actionlint
- **セキュリティスキャン**: Trivy（CRITICAL、HIGH、MEDIUM脆弱性検出）

## 開発環境
- **リージョン**: ap-northeast-1（東京）
- **プラットフォーム**: Darwin（macOS）
- **バックエンド暗号化**: 有効