module "hub" {
  source = "./hub"

  location      = "swedencentral"
  hub_vnet_cidr = "10.0.0.0/24"
}

module "spoke" {
  source = "./spoke-aks"

  hub_firewall_private_ip_address = module.hub.firewall_private_ip
  snet_hub_firewall_cidr          = module.hub.hub_vnet.snet_firewall_cidr
  hub_vnet_name                   = module.hub.hub_vnet.name
  hub_vnet_rg_name                = module.hub.hub_vnet.rg_name
  hub_vnet_id                     = module.hub.hub_vnet.id
}
