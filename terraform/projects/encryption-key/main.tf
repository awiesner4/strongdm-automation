locals {
  global_tags = {
    ch_cloud = var.ch_cloud
    ch_environment = var.ch_environment
    ch_team = var.ch_team
    ch_project = var.ch_project
    ch_user = var.ch_user
  }
}

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "kms" {
  source = "../../modules/kms-keys"
  kms_key_name = var.kms_key_name
  region = var.region
  kms_key_policy = var.kms_policy #file("./files/kms-policy.json")
  global_tags = local.global_tags
}
