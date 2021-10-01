locals {
  public_cidrs = length(var.private_subnet_zones) > 0 ? tomap({ for i, zone in var.private_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, i + var.subnet_cidrs_offset) }) : tomap({ for i, zone in var.public_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, i + var.subnet_cidrs_offset) })

  private_cidrs = tomap({
    for i, zone in var.private_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, length(local.public_cidrs) + i + var.subnet_cidrs_offset)
  })

  create_private_subnets = length(var.private_subnet_zones) > 0
}
