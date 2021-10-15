module "network" {
  source               = "../../"
  name                 = "name"
  region               = "eu-west-1"
  private_subnet_zones = ["a", "b", "c"]
}
