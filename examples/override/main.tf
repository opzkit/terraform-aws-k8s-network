module "network" {
  source               = "../../"
  name                 = "name"
  region               = "eu-west-1"
  public_subnet_cidrs  = { a = "172.20.32.0/19", b = "172.20.64.0/19", c = "172.20.96.0/19" }
  private_subnet_cidrs = { a = "173.20.32.0/19", b = "173.20.64.0/19", c = "173.20.96.0/19" }
}
