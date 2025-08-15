# コードベース構造

## ディレクトリ構成

```
my-modern-application-sample-infra/
├── aws/                      # AWSインフラストラクチャ
│   ├── environments/         # 環境別設定
│   │   ├── prod/            # 本番環境設定
│   │   │   ├── data_stores/ # データストア個別管理
│   │   │   │   ├── dynamodb/
│   │   │   │   └── rds/
│   │   │   ├── vpc/         # VPC個別管理
│   │   │   ├── api_gateway.tf
│   │   │   ├── appconfig.tf
│   │   │   ├── cognito.tf
│   │   │   ├── ecr.tf
│   │   │   ├── iam.tf
│   │   │   ├── lambda.tf    # 17のLambda関数定義
│   │   │   ├── s3.tf
│   │   │   ├── ses.tf
│   │   │   ├── sns.tf
│   │   │   ├── sqs.tf
│   │   │   ├── step_functions.tf
│   │   │   ├── variables.tf
│   │   │   ├── terraform.tf
│   │   │   ├── locals.tf
│   │   │   └── data.tf
│   │   └── backend.hcl.example
│   └── modules/             # 再利用可能モジュール（17種類）
│       ├── api_gateway_http/
│       ├── appconfig/
│       ├── aurora_serverless_v2/
│       ├── cognito_user_pool/
│       ├── dynamodb/
│       ├── ecr/
│       ├── ecs_cluster/
│       ├── ecs_service/
│       ├── github_actions_openid_connect_provider/
│       ├── github_actions_role/
│       ├── lambda/          # 主要なLambdaモジュール
│       ├── s3/
│       ├── ses/
│       ├── sns/
│       ├── sqs/
│       ├── step_functions/
│       └── vpc/
├── google/                  # Google Cloudインフラストラクチャ
│   ├── environments/
│   │   ├── prod/           # 本番環境設定
│   │   │   ├── main.tf     # Compute Engineインスタンス
│   │   │   ├── variables.tf
│   │   │   └── terraform.tf
│   │   └── backend.hcl.example
│   └── modules/            # Google Cloudモジュール（現在は空）
├── CLAUDE.md               # プロジェクト指針
├── README.md               # プロジェクト概要
├── .terraform-version      # Terraformバージョン固定
└── .gitignore             # Git管理対象外ファイル
```

## 主要ファイルの役割

### AWS環境設定（aws/environments/prod/）

#### メインリソース定義
- **lambda.tf**: 17のLambda関数定義（hello-world, register-user, send-emails等）
- **ecr.tf**: Lambda関数用のECRリポジトリ定義
- **api_gateway.tf**: HTTP APIとCognito統合
- **s3.tf**: 4つのS3バケット（read, write, contents, mail）
- **dynamodb**: data_stores/dynamodb/で個別管理
- **rds**: data_stores/rds/で個別管理
- **vpc**: vpc/で個別管理

#### 設定ファイル
- **variables.tf**: 環境固有変数（github_owner_name, github_repository_name等）
- **terraform.tf**: プロバイダーとバックエンド設定
- **locals.tf**: ローカル値定義
- **data.tf**: データソース定義

#### セキュリティ設定
- **iam.tf**: GitHub Actions用OIDCプロバイダーとロール
- **cognito.tf**: ユーザー認証設定

#### メッセージング
- **sqs.tf**: SQSキュー定義
- **sns.tf**: SNSトピック定義  
- **ses.tf**: メール送信設定

#### オーケストレーション
- **step_functions.tf**: Sagaパターンのワークフロー定義
- **appconfig.tf**: フィーチャーフラグ管理

### AWSモジュール（aws/modules/）

各モジュールは標準構造：
- **main.tf**: リソース定義
- **variables.tf**: 入力変数（日本語description）
- **outputs.tf**: 出力値

#### 主要モジュール
- **lambda/**: Lambda関数の標準テンプレート
  - コンテナベースパッケージング
  - 個別IAMロール
  - S3/SQSトリガー対応
  - X-Rayトレーシング対応
- **api_gateway_http/**: HTTP API + Cognito統合
- **vpc/**: VPC、サブネット、セキュリティグループ
- **aurora_serverless_v2/**: PostgreSQL Serverless v2
- **dynamodb/**: NoSQLテーブル定義

### Google Cloud設定（google/environments/prod/）

- **main.tf**: Compute Engineインスタンス定義
- **variables.tf**: プロジェクトID変数
- **terraform.tf**: Google Cloudプロバイダー設定

## Lambda関数一覧

### 基本関数
1. **lambda_hello_world**: 基本的なHelloWorldハンドラー
2. **lambda_tmp**: 実験用関数

### AWSサービス統合
3. **lambda_read_and_write_s3**: S3イベント処理
4. **lambda_register_user**: API Gateway + DynamoDB + S3 + SES統合
5. **lambda_feature_flags**: AppConfig統合
6. **lambda_auth_by_cognito**: Cognito JWTトークン検証
7. **lambda_access_rds**: RDS PostgreSQL接続

### メール処理
8. **lambda_send_message**: SQSメッセージ送信
9. **lambda_read_message_and_send_mail**: SQS→SES処理
10. **lambda_receive_bounce_mail**: メールバウンス処理

### Sagaオーケストレーション
11. **lambda_process_payment**: 決済処理
12. **lambda_cancel_payment**: 決済キャンセル（補償アクション）
13. **lambda_create_purchase_history**: 購入履歴作成
14. **lambda_delete_purchase_history**: 購入履歴削除（補償アクション）
15. **lambda_award_points**: ポイント付与

### ファンアウトパターン
16. **lambda_fan_out_consumer_1**: SNS/SQSファンアウトコンシューマー1
17. **lambda_fan_out_consumer_2**: SNS/SQSファンアウトコンシューマー2

## 状態管理設計

### 分離された状態管理
- **メインインフラ**: aws/environments/prod/
- **DynamoDB**: aws/environments/prod/data_stores/dynamodb/
- **RDS**: aws/environments/prod/data_stores/rds/
- **VPC**: aws/environments/prod/vpc/

### リモート状態参照
`terraform_remote_state`を使用してレイヤー間で状態を参照

## セキュリティ設計

### IAM権限
- Lambda関数ごとに個別の実行ロール
- 最小権限の原則適用
- 動的ポリシーステートメント対応

### ネットワーク
- VPCエンドポイント使用
- セキュリティグループによる通信制御
- プライベートサブネット配置