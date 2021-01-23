variable "dns_zone_name" {}
variable "vpc_id" {}
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
variable "region" {}