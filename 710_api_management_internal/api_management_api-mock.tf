resource "azurerm_api_management_api" "api-mock" {
  name                  = "api-mock"
  resource_group_name   = azurerm_api_management.apim.resource_group_name
  api_management_name   = azurerm_api_management.apim.name
  revision              = "v1"
  display_name          = "Mock API"
  path                  = "mock"
  api_type              = "http" # graphql, http, soap, and websocket
  protocols             = ["https"]
  subscription_required = false
}

resource "azurerm_api_management_api_operation" "operation-mock-get" {
  operation_id        = "api-mock-get"
  api_name            = azurerm_api_management_api.api-mock.name
  api_management_name = azurerm_api_management_api.api-mock.api_management_name
  resource_group_name = azurerm_api_management_api.api-mock.resource_group_name
  display_name        = "Mock API GET"
  method              = "GET"
  url_template        = "/"
  description         = "GET returns sample JSON file."

  response {
    status_code = 200

    representation {
      content_type = "application/json"

      example {
        name  = "default"
        value = <<JSON
{
  "title": "This is a mock API.",
  "description": "This a Mock response from API Management.",
  "purpose": "Mock API"
}
JSON
      }
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "mock-get-policy" {
  api_name            = azurerm_api_management_api_operation.operation-mock-get.api_name
  api_management_name = azurerm_api_management_api_operation.operation-mock-get.api_management_name
  resource_group_name = azurerm_api_management_api_operation.operation-mock-get.resource_group_name
  operation_id        = azurerm_api_management_api_operation.operation-mock-get.operation_id

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <mock-response status-code="200" content-type="application/json" />
  </inbound>
</policies>
XML
}
