locals {
  #  provisio_version  = "1.0.0"
  strongdmType = "gateway"
  #  aws_account       = "devops"
  #  hosted_zone_id    = "Z5RRIFZ668HAO"
  ec2_instance_name = "strongdm-${local.strongdmType}"
  deployment_name   = "strongDM Gateway Deployment"
  #  region            = "us-west-2"
  vpc_cidr = "172.0.0.0/16"
  vpc_name = "strongDM VPC"
  public_subnets = [
    { name = "Public strongDM DMZ AZ A", subnet_cidr = "172.0.0.0/24", az = "${var.region}a" },
    { name = "Public strongDM DMZ AZ B", subnet_cidr = "172.0.1.0/24", az = "${var.region}b" }
  ]
  private_subnets = [
    { name = "Private strongDM AZ A", subnet_cidr = "172.0.2.0/24", az = "${var.region}a" },
    { name = "Private strongDM AZ B", subnet_cidr = "172.0.3.0/24", az = "${var.region}b" }
  ]

  global_tags = {
    ch_cloud       = var.ch_cloud
    ch_environment = var.ch_environment
    ch_team        = var.ch_team
    ch_project     = var.ch_project
    ch_user        = var.ch_user
  }

  vpc_public       = true
  instance_profile = "strongdm-access-role"
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "infra" {
  source          = "../../modules/vpc"
  deployment_name = local.deployment_name
  region          = var.region
  vpc_cidr        = local.vpc_cidr
  vpc_name        = local.vpc_name
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  global_tags     = local.global_tags
}

data "aws_subnet_ids" "selected_subnets" {
  count  = local.vpc_public == true ? 1 : 0
  vpc_id = module.infra.vpc_id
  filter {
    name   = "map-public-ip-on-launch"
    values = [true]
  }
  depends_on = [module.infra]
}

module "security_group" {
  source      = "../../modules/sg"
  sg_name     = "strongdm-access-security-group"
  vpc_id      = module.infra.vpc_id
  global_tags = local.global_tags
}

module "ec2" {
  count                = length(local.private_subnets)
  source               = "../../modules/ec2"
  region               = var.region
  ec2_instance_name    = "${local.ec2_instance_name}-${count.index}"
  ec2_keypair          = var.ec2_keypair
  selected_subnets     = element(tolist(data.aws_subnet_ids.selected_subnets[0].ids), count.index)
  ec2_instance_public  = true
  vpc_id               = module.infra.vpc_id
  ec2_instance_profile = local.instance_profile
  provisio_version     = var.provisio_version
  zone_id              = var.hosted_zone_id
  dns_name             = "${local.ec2_instance_name}-${count.index}"
  security_group_id    = module.security_group.sg_id
  strongdmType         = local.strongdmType
  aws_account          = var.aws_account
  global_tags          = local.global_tags
}

resource "aws_route53_record" "strongDM" {
  count   = length(module.ec2.*.ec2_public_ip)
  name    = "strongdm-gateway-${count.index}"
  type    = "A"
  ttl     = "300"
  zone_id = var.hosted_zone_id
  records = [module.ec2.*.ec2_public_ip[count.index]]
}

