resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = var.name
  }
}

resource "aws_vpc_dhcp_options" "vpc" {
  domain_name = "${var.region}.compute.internal"
  domain_name_servers = [
  "AmazonProvidedDNS"]
  tags = {
    "Name" = var.name
  }
}

resource "aws_vpc_dhcp_options_association" "vpc" {
  dhcp_options_id = aws_vpc_dhcp_options.vpc.id
  vpc_id          = aws_vpc.vpc.id
}

resource "aws_eip" "elastic_ips" {
  for_each = local.private_cidrs
  tags = {
    "Name" = "${var.region}${each.key}.${var.name}"
  }
  domain = "vpc"
}

resource "aws_subnet" "private" {
  for_each          = local.private_cidrs
  availability_zone = "${var.region}${each.key}"
  cidr_block        = each.value
  vpc_id            = aws_vpc.vpc.id
  tags = merge({
    "Name"                            = "${var.region}${each.key}.${var.name}"
    "SubnetType"                      = "Private"
    "kubernetes.io/role/internal-elb" = "1"
  }, var.additional_private_subnet_tags)

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_subnet" "public" {
  for_each          = local.public_cidrs
  availability_zone = "${var.region}${each.key}"
  cidr_block        = each.value
  vpc_id            = aws_vpc.vpc.id
  tags = merge({
    "Name"                   = "public-${var.region}${each.key}.${var.name}"
    "SubnetType"             = "Utility"
    "kubernetes.io/role/elb" = "1"
  }, var.additional_public_subnet_tags)

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "nat_gw" {
  for_each      = local.create_private_subnets ? aws_subnet.public : {}
  allocation_id = aws_eip.elastic_ips[each.key].id
  subnet_id     = each.value.id
  tags = {
    "Name" = "${var.region}${each.key}.${var.name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = var.name
  }
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.vpc.id
  tags = {
    "Name" = "private-${var.region}${each.key}.${var.name}"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "route_private" {
  for_each               = aws_nat_gateway.nat_gw
  route_table_id         = aws_route_table.private[each.key].id
  nat_gateway_id         = aws_nat_gateway.nat_gw[each.key].id
  destination_cidr_block = "0.0.0.0/0"
}
