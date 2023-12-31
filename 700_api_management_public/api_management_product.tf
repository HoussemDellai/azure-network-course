resource "azurerm_api_management_product" "product-conference" {
  product_id            = "product-conference"
  api_management_name   = azurerm_api_management.apim.name
  resource_group_name   = azurerm_api_management.apim.resource_group_name
  display_name          = "Product Conference"
  subscription_required = true
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_product_api" "product-api" {
  api_name            = azurerm_api_management_api.api-conference.name
  product_id          = azurerm_api_management_product.product-conference.product_id
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_api_management.apim.resource_group_name
}