resource "azurerm_api_management_subscription" "subscription-conference" {
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_api_management.apim.resource_group_name
  user_id             = azurerm_api_management_user.user.id
  product_id          = azurerm_api_management_product.product-conference.id
  display_name        = "Subscription for Conference API"
  state               = "active" # active, cancelled, expired, rejected, submitted and suspended. Defaults to submitted
}
