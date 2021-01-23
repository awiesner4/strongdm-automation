provider "aws" {
  region = var.region
}

resource "aws_route53_zone" "private" {
  name = var.dns_zone_name

  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region
  }

  tags = merge(var.global_tags, map("Name", "strongDM-route53-zone"))
}