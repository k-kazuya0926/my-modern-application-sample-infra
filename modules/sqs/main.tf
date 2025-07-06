resource "aws_sqs_queue" "this" {
  name                       = "${var.github_repository_name}-${var.env}-${var.queue_name}"
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # Enable server-side encryption
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  # Dead letter queue configuration
  redrive_policy = var.dead_letter_queue_arn != null ? jsonencode({
    deadLetterTargetArn = var.dead_letter_queue_arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = var.tags
}

# Dead letter queue (optional)
resource "aws_sqs_queue" "dead_letter" {
  count = var.create_dead_letter_queue ? 1 : 0

  name                       = "${var.github_repository_name}-${var.env}-${var.queue_name}-dlq"
  delay_seconds              = 0
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.dead_letter_retention_seconds
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  # Enable server-side encryption
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = merge(var.tags, {
    Name = "${var.github_repository_name}-${var.env}-${var.queue_name}-dlq"
  })
}

# Queue policy (optional)
resource "aws_sqs_queue_policy" "this" {
  count = var.queue_policy != null ? 1 : 0

  queue_url = aws_sqs_queue.this.id
  policy    = var.queue_policy
}
