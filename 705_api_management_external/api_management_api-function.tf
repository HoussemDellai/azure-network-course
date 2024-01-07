resource "azurerm_api_management_api" "api-azure-function" {
  name                  = "api-demo"
  resource_group_name   = azurerm_api_management.apim.resource_group_name
  api_management_name   = azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "Demo API"
  path                  = "api"
  api_type              = "http" # graphql, http, soap, and websocket
  protocols             = ["http", "https"]
  service_url           = "https://${azurerm_linux_function_app.function-linux-container.default_hostname}/api"
  subscription_required = false
}

resource "azurerm_api_management_api_operation" "operation-azure-function-get" {
  operation_id        = "api-demo-get"
  api_name            = azurerm_api_management_api.api-azure-function.name
  api_management_name = azurerm_api_management_api.api-azure-function.api_management_name
  resource_group_name = azurerm_api_management_api.api-azure-function.resource_group_name
  display_name        = "Demo API GET"
  method              = "GET"
  url_template        = "/"
  description         = "GET returns sample JSON file."
}