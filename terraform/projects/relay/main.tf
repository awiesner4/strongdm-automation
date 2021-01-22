locals {
  provisio_version  = "1.0.0"
  strongdmType      = "relay"
  ec2_instance_name = "strongdm-Relay"
  deployment_name   = "strongDM Deployment"
  region            = "us-west-2"
  vpc_cidr          = "172.0.0.0/16"
  vpc_name          = "strongDM VPC"
  public_subnets = [
    { name = "Public strongDM DMZ AZ A", subnet_cidr = "172.0.0.0/24", az = "us-west-2a" },
    { name = "Public strongDM DMZ B", subnet_cidr = "172.0.1.0/24", az = "us-west-2b" }

  ]
  private_subnets = [
    { name = "Private strongDM AZ A", subnet_cidr = "172.0.2.0/24", az = "us-west-2a" },
    { name = "Private strongDM AZ B", subnet_cidr = "172.0.3.0/24", az = "us-west-2b" }
  ]

  global_tags = {
    ch_cloud        = "aws"
    ch_environment  = "devops"
    ch_organization = "engineering"
    ch_team         = "galactic-empire"
    ch_project      = "saas"
    ch_user         = "automation"
  }
  dns_zone_name    = "devops.galaxy"
  vpc_private      = true
  instance_profile = "strongdm-instance-profile"
}
provider "aws" {
  region = local.region
}

module "infra" {
  source          = "..\/..\/modules\/vpc"
  deployment_name = local.deployment_name
  region          = local.region
  vpc_cidr        = local.vpc_cidr
  vpc_name        = local.vpc_name
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  global_tags     = local.global_tags
}

module "route53" {
  source        = "..\/..\/modules\/route53"
  dns_zone_name = local.dns_zone_name
  vpc_id        = module.infra.vpc_id
  global_tags   = local.global_tags
  region        = local.region
}

data "aws_subnet_ids" "selected_subnets" {
  count  = local.vpc_private == true ? 1 : 0
  vpc_id = module.infra.vpc_id
  filter {
    name   = "map-public-ip-on-launch"
    values = [false]
  }
  depends_on = [module.infra]
}

module "security_group" {
  source = "..\/..\/modules\/sg"
  sg_name = "strongdm-access-security-group"
  vpc_id = module.infra.vpc_id
  port = 22
}

module "ec2" {
  count                = length(local.private_subnets)
  source               = "..\/..\/modules\/ec2"
  region               = local.region
  ec2_instance_name    = "${local.ec2_instance_name}-${count.index}"
  ec2_keypair          = "automation-devops-west"
  selected_subnets     = element(tolist(data.aws_subnet_ids.selected_subnets[0].ids), count.index)
  ec2_instance_public  = false
  vpc_id               = module.infra.vpc_id
  ec2_instance_profile = local.instance_profile
  provisio_version     = local.provisio_version
  zone_id              = module.route53.hosted_zone_id
  dns_name             = "${local.ec2_instance_name}-${count.index}"
  security_group_id   = module.security_group.sg_id
}

resource "aws_route53_record" "strongDM" {
  count   = length(module.ec2.*.ec2_private_ip)
  name    = "strongdm-relay-${count.index}"
  type    = "A"
  ttl     = "300"
  zone_id = local.hosted_zone_id
  records = [module.ec2.*.ec2_private_ip[count.index]]
}

