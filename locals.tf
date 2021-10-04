locals {
  cidrs = cidrsubnets(var.vpc_cidr, 3, 3, 3, 3, 3, 3)

  number_of_private_zones = length(var.private_subnet_zones)
  create_private_subnets  = local.number_of_private_zones > 0

  provided_cidrs_from_private_zones = length(var.public_subnet_cidrs) > 0 ? zipmap(var.private_subnet_zones, var.public_subnet_cidrs) : {}
  provided_cidrs_from_public_zones  = length(var.public_subnet_cidrs) > 0 ? zipmap(var.public_subnet_zones, var.public_subnet_cidrs) : {}
  provided_cidrs                    = local.create_private_subnets ? local.provided_cidrs_from_private_zones : local.provided_cidrs_from_public_zones

  generated_cidrs_from_private_zones = zipmap(var.private_subnet_zones, slice(local.cidrs, 0, local.number_of_private_zones))
  generated_cidrs_from_public_zones  = zipmap(var.public_subnet_zones, slice(local.cidrs, 0, length(var.public_subnet_zones)))
  generated_cidrs                    = local.create_private_subnets ? local.generated_cidrs_from_private_zones : local.generated_cidrs_from_public_zones

  public_cidrs  = length(var.public_subnet_cidrs) > 0 ? local.provided_cidrs : local.generated_cidrs
  private_cidrs = length(var.private_subnet_cidrs) > 0 ? zipmap(var.private_subnet_zones, var.private_subnet_cidrs) : zipmap(var.private_subnet_zones, slice(local.cidrs, length(local.public_cidrs), length(local.public_cidrs) + local.number_of_private_zones))
}
