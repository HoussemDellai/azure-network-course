module "hub" {
  source = "./modules/hub"

  location      = "swedencentral"
  hub_vnet_cidr = "10.0.0.0/24"
}

module "spoke-aks-firewall" {
  source = "./modules/spoke-aks-firewall"

  spoke_vnet_cidrs                = ["10.0.1.0/26", "100.64.0.0/10"]
  hub_firewall_private_ip_address = module.hub.firewall_private_ip
  snet_hub_firewall_cidr          = module.hub.hub_vnet.snet_firewall_cidr
  hub_vnet_name                   = module.hub.hub_vnet.name
  hub_vnet_rg_name                = module.hub.hub_vnet.rg_name
  hub_vnet_id                     = module.hub.hub_vnet.id
}
