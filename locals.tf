locals {
  cidrs = cidrsubnets(var.vpc_cidr, 3, 3, 3, 3, 3, 3)

  public_zones_to_cidr  = zipmap(["a", "b", "c"], slice(local.cidrs, 0, 3))
  private_zones_to_cidr = zipmap(["a", "b", "c"], slice(local.cidrs, 3, 6))

  // if private zones > public zones
  // replace with private zones
  public_zones  = length(var.public_subnet_zones) < length(var.private_subnet_zones) ? var.private_subnet_zones : var.public_subnet_zones
  private_zones = var.private_subnet_zones

  // if provided zones
  override = length(var.public_subnet_cidrs) > 0

  create_private_subnets = length(var.private_subnet_zones) > 0

  public_cidrs  = local.override ? var.public_subnet_cidrs : tomap({ for z in local.public_zones : z => local.public_zones_to_cidr[z] })
  private_cidrs = local.override ? var.private_subnet_cidrs : tomap({ for z in local.private_zones : z => local.private_zones_to_cidr[z] })
}
