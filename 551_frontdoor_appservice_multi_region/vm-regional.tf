module "vm-region1" {
  source = "./modules/vm-windows"

  prefix   = var.prefix
  location = var.location1
}

module "vm-region2" {
  source = "./modules/vm-windows"

  prefix   = var.prefix
  location = var.location2
}

module "vm-region3" {
  source = "./modules/vm-windows"

  prefix   = var.prefix
  location = var.location3
}
