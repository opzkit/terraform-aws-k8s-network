module "network" {
  source              = "../../"
  name                = "name"
  region              = "eu-west-1"
  public_subnet_zones = ["a", "b", "c"]
  s3_service_endpoint = true
}
