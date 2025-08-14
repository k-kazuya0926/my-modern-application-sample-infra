output "bucket_name" {
  description = "S3バケット名"
  value       = aws_s3_bucket.this.id
}

output "bucket_id" {
  description = "S3バケットID（bucket_nameのエイリアス）"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "S3バケットのARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "S3バケットのドメイン名"
  value       = "${aws_s3_bucket.this.id}.s3.amazonaws.com"
}

output "bucket_regional_domain_name" {
  description = "S3バケットのリージョナルドメイン名"
  value       = "${aws_s3_bucket.this.id}.s3.${data.aws_region.current.id}.amazonaws.com"
}

output "bucket_website_endpoint" {
  description = "S3バケットのウェブサイトエンドポイント（非推奨のため削除予定）"
  value       = null
}

output "bucket_hosted_zone_id" {
  description = "S3バケットのホストゾーンID（ap-northeast-1用、他のリージョンでは要更新）"
  value       = data.aws_region.current.id == "ap-northeast-1" ? "Z2M4EHUR26P7ZW" : null
}

output "bucket_region" {
  description = "S3バケットのリージョン"
  value       = data.aws_region.current.id
}

output "bucket_tags" {
  description = "S3バケットに適用されたタグ"
  value       = aws_s3_bucket.this.tags_all
}

output "public_access_block_id" {
  description = "パブリックアクセスブロック設定のID"
  value       = aws_s3_bucket_public_access_block.this.id
}

output "versioning_enabled" {
  description = "バージョニングが有効かどうか"
  value       = var.versioning_enabled
}

output "encryption_configuration" {
  description = "暗号化設定の詳細"
  value = {
    sse_algorithm      = var.kms_master_key_id != null ? "aws:kms" : "AES256"
    kms_key_id         = var.kms_master_key_id
    bucket_key_enabled = var.bucket_key_enabled
  }
}

output "lifecycle_rules_count" {
  description = "設定されたライフサイクルルールの数"
  value       = length(var.lifecycle_rules)
}

output "cors_rules_count" {
  description = "設定されたCORSルールの数"
  value       = length(var.cors_rules)
}

output "notifications_configured" {
  description = "通知設定の状況"
  value = {
    lambda_notifications = length(var.lambda_notifications) > 0
    sqs_notifications    = length(var.sqs_notifications) > 0
    sns_notifications    = length(var.sns_notifications) > 0
  }
}
