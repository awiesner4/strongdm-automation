
variable "deployment_name" {
  type    = string
  default = "strongDM Gateway"
}
variable "region" {
  type    = string
  default = "us-west-2"
}
variable "vpc_cidr" {
  type    = string
  default = "172.0.0.0/16"
}
variable "vpc_name" {
  type    = string
  default = "strongDM-VPC"
}
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
variable "public_subnets" {
  default = [
    { name = "Public strongDM DMZ A", subnet_cidr = "172.0.0.0/24", az = "us-west-2a" },
    { name = "Public strongDM DMZ B", subnet_cidr = "172.0.1.0/24", az = "us-west-2b" }
  ]
}
variable "private_subnets" {
  default = [
    { name = "Private strongDM A", subnet_cidr = "172.0.2.0/24", az = "us-west-2a" },
    { name = "Private strongDM B", subnet_cidr = "172.0.3.0/24", az = "us-west-2b" }
  ]
}