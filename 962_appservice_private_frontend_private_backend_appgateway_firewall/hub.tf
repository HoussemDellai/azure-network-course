module "hub" {
  source = "../modules/hub"

  location            = var.location
  prefix = var.prefix
}