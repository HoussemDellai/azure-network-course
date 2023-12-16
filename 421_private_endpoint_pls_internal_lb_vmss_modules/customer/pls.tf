resource "azurerm_private_link_service" "pls" {
  name                = "pls-privatelink"
  resource_group_name = azurerm_resource_group.rg-customer.name
  location            = azurerm_resource_group.rg-customer.location

  auto_approval_subscription_ids              = [data.azurerm_subscription.current.subscription_id]
  visibility_subscription_ids                 = [data.azurerm_subscription.current.subscription_id]
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.lb-internal.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name      = "primary"
    subnet_id = azurerm_subnet.subnet-customer.id
    primary   = true
    # private_ip_address         = "10.5.1.17"
    # private_ip_address_version = "IPv4"

  }
}

data "azurerm_subscription" "current" {
}
