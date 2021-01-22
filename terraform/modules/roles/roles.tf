resource "aws_iam_policy" "strongdm-cicd-s3-access-policy" {
  name   = "strongdm-cicd-s3-provisio-access"
  policy = file("${path.module}/files/cicd-s3-provisio-access.json")
}

resource "aws_iam_policy" "strongdm-kms-key-access-policy" {
  name = "strongdm-kms-key-access"
  policy = templatefile("${path.module}/templates/kms-key-access-policy.json.tmpl",
    {
      region          = var.region,
      kms_key_account = var.kms_key_account,
      kms_key_id      = var.kms_key_id
    }
  )
}

resource "aws_iam_policy" "strongdm-asm-access" {
  name = "strongdm-asm-access"
  policy = templatefile("${path.module}/templates/secrets-manager-access-policy.json.tmpl",
    {
      region             = var.region,
      asm_secret_account = var.asm_secret_account,
      asm_secret_name    = var.asm_secret_name
    }
  )
}

resource "aws_iam_policy" "strongdm-local-policies" {
  name   = "strongdm-local-policies"
  policy = file("${path.module}/files/local-account-policy.json")
}

resource "aws_iam_role" "strongdm-role" {
  name               = "strongdm-access-role"
  description        = "Managed by Terraform"
  assume_role_policy = file("${path.module}/files/assume-role-policy.json")
  tags = merge({
    Name = "strongdm-access-role"
  }, var.global_tags)
}

resource "aws_iam_role_policy_attachment" "strongdm-cicd-s3-attach" {
  role       = aws_iam_role.strongdm-role.name
  policy_arn = aws_iam_policy.strongdm-cicd-s3-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "strongdm-kms-key-attach" {
  role       = aws_iam_role.strongdm-role.name
  policy_arn = aws_iam_policy.strongdm-kms-key-access-policy.arn
}

resource "aws_iam_role_policy_attachment" "strongdm-asm-attach" {
  role       = aws_iam_role.strongdm-role.name
  policy_arn = aws_iam_policy.strongdm-asm-access.arn
}

resource "aws_iam_role_policy_attachment" "strongdm-local-attach" {
  role       = aws_iam_role.strongdm-role.name
  policy_arn = aws_iam_policy.strongdm-local-policies.arn
}

resource "aws_iam_instance_profile" "strongdm-instance-profile" {
  name = "strongdm-access-role"
  role = aws_iam_role.strongdm-role.name
}