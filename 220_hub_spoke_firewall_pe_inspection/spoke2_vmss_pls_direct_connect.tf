# resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
#   name                            = "vmss-inspector-gadget"
#   resource_group_name             = azurerm_resource_group.rg-spoke2.name
#   location                        = azurerm_resource_group.rg-spoke2.location
#   instances                       = 2
#   sku                             = "Standard_D2ads_v6"
#   zones                           = ["1", "2", "3"]
#   disable_password_authentication = false
#   admin_username                  = "azureuser"
#   admin_password                  = "@Aa123456789"
#   priority                        = "Spot"
#   eviction_policy                 = "Delete"

#   custom_data = filebase64("../scripts/install-docker-inspector-gadget.sh")

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts" # "0001-com-ubuntu-server-jammy"
#     sku       = "server"           # "22_04-lts"
#     version   = "latest"
#   }

#   network_interface {
#     name                      = "nic-vmss"
#     primary                   = true
#     enable_ip_forwarding      = false
#     network_security_group_id = null

#     ip_configuration {
#       name                                         = "internal"
#       primary                                      = true
#       subnet_id                                    = azurerm_subnet.snet-spoke2-vm.id
#       application_gateway_backend_address_pool_ids = null
#       load_balancer_inbound_nat_rules_ids          = null
#     }
#   }
# }

# resource "azurerm_private_link_service" "pls-vmss" {
#   name                = "pls-vmss"
#   resource_group_name = azurerm_resource_group.rg-spoke2.name
#   location            = azurerm_resource_group.rg-spoke2.location

#   # auto_approval_subscription_ids              = [data.azurerm_subscription.current.subscription_id]
#   # visibility_subscription_ids                 = [data.azurerm_subscription.current.subscription_id]
#   # load_balancer_frontend_ip_configuration_ids = [azurerm_lb.ilb-vmss.frontend_ip_configuration.0.id]

#   # Destination IP address for direct routing
#   destination_ip_address = "10.2.2.8"

#   # Minimum 2 IP configurations required for destination IP
#   nat_ip_configuration {
#     name     = "ipconfig1"
#     primary  = true
#     subnet_id = azurerm_subnet.snet-spoke2-vm.id
#   }

#   nat_ip_configuration {
#     name     = "ipconfig2"
#     primary  = false
#     subnet_id = azurerm_subnet.snet-spoke2-vm.id
#   }
# }

# data "azurerm_subscription" "current" {
# }

# resource "azurerm_private_endpoint" "pe-vmss" {
#   name                          = "pe-vmss"
#   location                      = azurerm_resource_group.rg-spoke2.location
#   resource_group_name           = azurerm_resource_group.rg-spoke2.name
#   subnet_id                     = azurerm_subnet.snet-spoke2-pe.id
#   custom_network_interface_name = "nic-pe-vmss"

#   private_service_connection {
#     name                           = "pls-connection"
#     private_connection_resource_id = azurerm_private_link_service.pls-vmss.id
#     is_manual_connection           = false
#   }

#   #   DNS configuration is not available for private endpoints connected to a private link service.
#   #   private_dns_zone_group {
#   #     name                 = "private-dns-zone-group"
#   #     private_dns_zone_ids = [azurerm_private_dns_zone.private-dns-zone.id]
#   #   }
# }

# output "vmss_pe_ip" {
#   value = azurerm_private_endpoint.pe-vmss.private_service_connection.0.private_ip_address
# }

# output "pls_destination_ip" {
#   value       = azurerm_private_link_service.pls-vmss.destination_ip_address
# }