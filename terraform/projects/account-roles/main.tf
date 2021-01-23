locals {
  global_tags = {
    ch_cloud       = var.ch_cloud
    ch_environment = var.ch_environment
    ch_team        = var.ch_team
    ch_project     = var.ch_project
    ch_user        = var.ch_user
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "strongdm-roles" {
  source             = "../../modules/roles"
  region             = var.region
  kms_key_account    = var.kms_key_account
  kms_key_id         = var.kms_key_id
  asm_secret_account = var.asm_secret_account
  asm_secret_name    = var.asm_secret_name
  global_tags        = local.global_tags
}

