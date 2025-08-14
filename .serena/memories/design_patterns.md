# 設計パターンとガイドライン

## アーキテクチャパターン

### Lambda関数アーキテクチャ
- **コンテナベース**: ECRからのコンテナイメージ使用（ZIPファイル禁止）
- **個別IAMロール**: 関数ごとに専用実行ロール
- **最小権限の原則**: `policy_statements`による具体的権限定義
- **環境変数注入**: Terraform経由での設定

### メッセージングパターン
- **ファンアウト**: SNS/SQSによる複数コンシューマー
- **キューイング**: SQSによる非同期処理
- **イベント駆動**: S3イベントトリガー

### データストレージパターン
- **NoSQL**: DynamoDB（個別状態管理）
- **リレーショナル**: Aurora Serverless v2（自動スケーリング）
- **オブジェクトストレージ**: S3（用途別バケット分離）

### オーケストレーションパターン
- **Sagaパターン**: Step Functionsによる分散トランザクション
- **補償アクション**: 失敗時の自動回復

## セキュリティパターン

### IAM設計
```hcl
# 個別実行ロール
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.github_repository_name}-${var.env}-${var.function_name}-role"
  # ...
}

# 動的ポリシーステートメント
dynamic "statement" {
  for_each = var.policy_statements
  content {
    effect    = statement.value.effect
    actions   = statement.value.actions
    resources = statement.value.resources
  }
}
```

### OIDC統合
- GitHub ActionsからのOIDC認証
- 一時的な認証情報使用
- ロールベースアクセス制御

## モジュール設計パターン

### 標準構造
```
module_name/
├── main.tf         # リソース定義
├── variables.tf    # 入力変数（日本語description）
└── outputs.tf      # 出力値
```

### 条件付きリソース
```hcl
# count による条件分岐
resource "aws_s3_bucket_notification" "lambda_trigger" {
  count  = var.s3_trigger_bucket_name != null ? 1 : 0
  bucket = var.s3_trigger_bucket_name
  # ...
}
```

### 動的設定
```hcl
# 柔軟なIAMポリシー
dynamic "statement" {
  for_each = var.policy_statements
  content {
    # 動的ブロック内容
  }
}
```

## 命名パターン

### リソース命名
- **形式**: `${var.github_repository_name}-${var.env}-${specific_name}`
- **例**: `my-app-prod-lambda-hello-world`

### 変数命名
- **スネークケース**: `environment_variables`
- **具体的**: `s3_trigger_bucket_name`
- **説明的**: `log_retention_days`

## エラーハンドリングパターン

### バリデーション
```hcl
validation {
  condition = contains([
    1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180
  ], var.log_retention_days)
  error_message = "有効なCloudWatch Logsの保持期間である必要があります。"
}
```

### フェイルセーフ
- デフォルト値の適切な設定
- オプショナル設定の`null`許可
- 段階的デグラデーション