resource "aws_sns_topic" "this" {
  name                                     = "${var.github_repository_name}-${var.env}-${var.topic_name}"
  display_name                             = var.display_name
  policy                                   = var.topic_policy
  delivery_policy                          = var.delivery_policy
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn
  http_success_feedback_role_arn           = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate        = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn           = var.http_failure_feedback_role_arn
  lambda_success_feedback_role_arn         = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate      = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn         = var.lambda_failure_feedback_role_arn
  sqs_success_feedback_role_arn            = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate         = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn            = var.sqs_failure_feedback_role_arn
  fifo_topic                               = var.fifo_topic
  content_based_deduplication              = var.content_based_deduplication
  kms_master_key_id                        = var.kms_master_key_id

  tags = var.tags
}

# SNSトピック購読
resource "aws_sns_topic_subscription" "this" {
  count                           = length(var.subscriptions)
  topic_arn                       = aws_sns_topic.this.arn
  protocol                        = var.subscriptions[count.index].protocol
  endpoint                        = var.subscriptions[count.index].endpoint
  confirmation_timeout_in_minutes = var.subscriptions[count.index].confirmation_timeout_in_minutes
  endpoint_auto_confirms          = var.subscriptions[count.index].endpoint_auto_confirms
  raw_message_delivery            = var.subscriptions[count.index].raw_message_delivery
  filter_policy                   = var.subscriptions[count.index].filter_policy
  filter_policy_scope             = var.subscriptions[count.index].filter_policy_scope
  delivery_policy                 = var.subscriptions[count.index].delivery_policy
  redrive_policy                  = var.subscriptions[count.index].redrive_policy
}
