module "hub" {
  source = "../modules/hub"

  prefix   = "962"
  location = "swedencentral"
}

module "spoke-appservice1" {
  source = "./modules/spoke-appservice"

  prefix              = "962-001"
  location            = "swedencentral"
  spoke_vnet_cidr     = "10.1.0.0/16"
  hub_vnet_id         = module.hub.hub_vnet.id
  hub_vnet_name       = module.hub.hub_vnet.name
  hub_vnet_rg_name    = module.hub.hub_vnet.rg_name
  firewall_private_ip = module.hub.firewall_private_ip
}

module "spoke-appservice2" {
  source = "./modules/spoke-appservice"

  prefix              = "962-002"
  location            = "swedencentral"
  spoke_vnet_cidr     = "10.2.0.0/16"
  hub_vnet_id         = module.hub.hub_vnet.id
  hub_vnet_name       = module.hub.hub_vnet.name
  hub_vnet_rg_name    = module.hub.hub_vnet.rg_name
  firewall_private_ip = module.hub.firewall_private_ip
}
