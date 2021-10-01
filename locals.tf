locals {
  create_private_subnets = length(var.private_subnet_zones) > 0

  provided_cidrs = local.create_private_subnets ? tomap({
    for i, zone in var.private_subnet_zones : zone => var.public_subnet_cidrs[i] }) : tomap({
  for i, zone in var.public_subnet_zones : zone => var.public_subnet_cidrs[i] })

  generated_cidrs = local.create_private_subnets ? tomap({
    for i, zone in var.private_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, i) }) : tomap({
  for i, zone in var.public_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, i) })

  public_cidrs = length(var.public_subnet_cidrs) > 0 ? local.provided_cidrs : local.generated_cidrs

  private_cidrs = length(var.private_subnet_cidrs) > 0 ? tomap({
    for i, zone in var.private_subnet_zones : zone => var.private_subnet_cidrs[i] }) : tomap({
    for i, zone in var.private_subnet_zones : zone => cidrsubnet(var.vpc_cidr, 3, length(local.public_cidrs) + i)
  })
}
