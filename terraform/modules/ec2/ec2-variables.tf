variable "provisio_version" {
  default = "1.0.0"
}
variable "strongdmType" {
  default = "relay"
}

variable "aws_account" {}

variable "security_group_id" {}

variable "dns_name" {}

variable "zone_id" {}

variable "region" {}

variable "ec2_instance_name" {
  type = string
}

variable "ec2_ssh_port" {
  type    = number
  default = 22
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "ec2_keypair" {
  type = string
}

variable "ec2_user_data" {
  type        = string
  default     = "provisio.main.sh"
  description = "The user_data file to do the initial compute provisioning"
}

variable "ec2_root_block_device_type" {
  type    = string
  default = "gp2"
}

variable "ec2_root_block_device_size" {
  type    = number
  default = 10
}

variable "ec2_root_block_device_delete_on_termination" {
  type    = bool
  default = true
}

variable "ec2_instance_public" {
  type    = bool
  default = true
}

variable "ec2_instance_profile" {
  type    = string
  default = ""
}

variable "vpc_id" {}

variable "selected_subnets" {}

variable "global_tags" {
  default = {
    ch_cloud = "aws"
    ch_environment = "devops"
    ch_organization = "engineering"
    ch_team = "galactic-empire"
    ch_project = "saas"
    ch_user = "automation"
  }
}