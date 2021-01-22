
resource "aws_kms_key" "strongdm-keys" {
  description = "Encrypt strongDM secrets"
  key_usage = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days = 7
  policy = var.kms_key_policy
  tags = merge({
    Name = var.kms_key_name
  }, var.global_tags)
}

resource "aws_kms_alias" "strongdm-keys" {
  name = "alias/${var.kms_key_name}"
  target_key_id = aws_kms_key.strongdm-keys.key_id
}