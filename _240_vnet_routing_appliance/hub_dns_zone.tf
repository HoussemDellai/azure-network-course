# Private DNS Zone to configure the domain name

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "internal.corp"
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_a_record" "dns_a_record" {
  name                = "test"
  private_dns_zone_id = azurerm_private_dns_zone.dns_zone.id
  ttl                 = 300
  records             = ["1.2.3.4"] # just example IP address
}

resource "azurerm_private_dns_a_record" "dns_a_record_vm_spoke1" {
  name                = "vm1"
  private_dns_zone_id = azurerm_private_dns_zone.dns_zone.id
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.vm_spoke1.private_ip_address]
}

resource "azurerm_private_dns_a_record" "dns_a_record_vm_spoke2" {
  name                = "vm2"
  private_dns_zone_id = azurerm_private_dns_zone.dns_zone.id
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine.vm_spoke2.private_ip_address]
}

# DNS Zone link to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "link_vnet_hub_dns_zone" {
  name                  = "link-vnet-hub-dns-zone"
  private_dns_zone_id = azurerm_private_dns_zone.dns_zone.id
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}