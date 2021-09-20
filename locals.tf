locals {
  public_cidrs = length(var.private_subnet_zones) > 0 ? tomap({ for i, zone in var.private_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, i) }) : tomap({ for i, zone in var.public_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, i) })

  private_cidrs = tomap({
    for i, zone in var.private_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, length(local.public_cidrs) + i)
  })
}
