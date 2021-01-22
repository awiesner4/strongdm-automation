provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.global_tags, map("Name", var.vpc_name))
}

resource "aws_subnet" "public" {
  for_each = { for subnet in var.public_subnets : subnet.name => subnet }
  cidr_block = each.value.subnet_cidr
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone = each.value.az
  tags = merge(var.global_tags, map("Name", each.value.name))
}

resource "aws_subnet" "private" {
  for_each = { for subnet in var.private_subnets : subnet.name => subnet }
  cidr_block = each.value.subnet_cidr
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = false
  availability_zone = each.value.az
  tags = merge(var.global_tags, map("Name", each.value.name))
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = var.global_tags
}

resource "aws_eip" "elastic_ip" {
  tags = merge(var.global_tags, map("Name", "${var.deployment_name}-NAT-IP"))
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = aws_subnet.public[var.public_subnets[0].name].id

  depends_on = [aws_internet_gateway.igw, aws_eip.elastic_ip]
  tags = merge(var.global_tags, map("Name", "${var.deployment_name}-public"))
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_subnet.public]
  tags = merge(var.global_tags, map("Name", "${var.deployment_name}-public"))
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  depends_on = [aws_subnet.public]
  tags = merge(var.global_tags, map("Name", "${var.deployment_name}-private"))
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  for_each = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  for_each = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id
}