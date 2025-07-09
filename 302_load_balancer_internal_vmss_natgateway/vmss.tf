resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = "vmss-app"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  instances                       = 3
  sku                             = "Standard_D2ads_v6"
  zones                           = ["1", "2", "3"]
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  priority                        = "Spot"
  eviction_policy                 = "Delete"

  custom_data = filebase64("./install-webapp.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts" # "0001-com-ubuntu-server-jammy"
    sku       = "server"           # "22_04-lts"
    version   = "latest"
  }

  network_interface {
    name                      = "nic-vmss"
    primary                   = true
    enable_ip_forwarding      = false
    network_security_group_id = null

    ip_configuration {
      name                                         = "internal"
      primary                                      = true
      subnet_id                                    = azurerm_subnet.subnet-app.id
      load_balancer_backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend-pool.id]
      application_gateway_backend_address_pool_ids = null
      load_balancer_inbound_nat_rules_ids          = null
    }
  }
}
