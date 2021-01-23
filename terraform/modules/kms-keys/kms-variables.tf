variable "kms_key_name" {}
variable "region" {}
variable "kms_key_policy" {}
variable "global_tags" {
  default = {
    ch_cloud        = "aws"
    ch_environment  = "devops"
    ch_organization = "engineering"
    ch_team         = "galactic-empire"
    ch_project      = "saas"
    ch_user         = "automation"
  }
}