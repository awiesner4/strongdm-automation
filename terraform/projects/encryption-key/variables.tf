variable "region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "kms_key_name" {}
variable "ch_cloud" {}
variable "ch_environment" {}
variable "ch_team" {}
variable "ch_project" {}
variable "ch_user" {}

variable "kms_policy" {
  default = <<EOF
{
  "Id": "strongdm-key-access-policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::796319636790:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for Key Administrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::796319636790:role/devops"
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow use of the key",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::796319636790:role/platform-team",
          "arn:aws:iam::796319636790:role/devops",
          "arn:aws:iam::376480939537:root",
          "arn:aws:iam::723392335879:root",
          "arn:aws:iam::327426148791:root",
          "arn:aws:iam::888469412714:root",
          "arn:aws:iam::213470952269:root",
          "arn:aws:iam::214608885436:root",
          "arn:aws:iam::035861696447:root"
        ]
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::796319636790:role/platform-team",
          "arn:aws:iam::796319636790:role/devops",
          "arn:aws:iam::376480939537:root",
          "arn:aws:iam::723392335879:root",
          "arn:aws:iam::327426148791:root",
          "arn:aws:iam::888469412714:root",
          "arn:aws:iam::213470952269:root",
          "arn:aws:iam::214608885436:root",
          "arn:aws:iam::035861696447:root"
        ]
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    }
  ]
}
EOF
}