module "network" {
  source = "../../"
  name   = "name"
  region = "eu-west-1"
  #  public_subnet_zones  = ["a", "b", "c"]
  private_subnet_zones = ["a", "b", "c"]
  public_subnet_cidrs  = ["172.20.32.0/19", "172.20.64.0/19", "172.20.96.0/19"]
  private_subnet_cidrs = ["173.20.32.0/19", "173.20.64.0/19", "173.20.96.0/19"]
}
