resource "aws_dynamodb_table" "this" {
  name                        = "${var.github_repository_name}-${var.env}-${var.table_name}"
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  read_capacity               = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity              = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type
      read_capacity   = var.billing_mode == "PROVISIONED" ? (global_secondary_index.value.read_capacity != null ? global_secondary_index.value.read_capacity : var.read_capacity) : null
      write_capacity  = var.billing_mode == "PROVISIONED" ? (global_secondary_index.value.write_capacity != null ? global_secondary_index.value.write_capacity : var.write_capacity) : null
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name            = local_secondary_index.value.name
      range_key       = local_secondary_index.value.range_key
      projection_type = local_secondary_index.value.projection_type
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = var.ttl_enabled
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  tags = var.tags
}

resource "aws_dynamodb_table_item" "initial_items" {
  count      = length(var.initial_items)
  table_name = aws_dynamodb_table.this.name
  hash_key   = aws_dynamodb_table.this.hash_key
  range_key  = aws_dynamodb_table.this.range_key

  item = jsonencode(var.initial_items[count.index].item)

  lifecycle {
    ignore_changes = [item]
  }
}
