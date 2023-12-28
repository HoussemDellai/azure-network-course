resource "azurerm_api_management" "apim" {
  name                 = "apim-dev-700-prod"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  publisher_name       = "My Company"
  publisher_email      = "houssem.dellai@live.com"
  sku_name             = "Developer_1"
  # virtual_network_type = "External" # None, External, Internal

  # public_ip_address_id = azurerm_public_ip.pip-apim.id
  # public_network_access_enabled = true

  # virtual_network_configuration {
  #   subnet_id = azurerm_subnet.subnet-app.id
  # }
}

resource "azurerm_api_management_api" "api-mock" {
  name                = "api-mock"
  resource_group_name = azurerm_api_management.apim.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision            = "v1"
  display_name        = "Mock API"
  path                = "mock"
  api_type            = "http" # graphql, http, soap, and websocket
  protocols           = ["https"]
}

resource "azurerm_api_management_api_operation" "operation-mock-get" {
  operation_id        = "api-mock-get"
  api_name            = azurerm_api_management_api.api-mock.name
  api_management_name = azurerm_api_management_api.api-mock.api_management_name
  resource_group_name = azurerm_api_management_api.api-mock.resource_group_name
  display_name        = "Mock API GET"
  method              = "GET"
  url_template        = "/mock"
  description         = "GET returns sample JSON file."

  response {
    status_code = 200

    representation {
      content_type = "application/json"

      example {
        name  = "default"
        value = <<JSON
{
  "sampleField": "test"
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

resource "azurerm_api_management_api" "api-conference" {
  name                = "api-conference"
  resource_group_name = azurerm_api_management.apim.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Conference API"
  path                = "conference"
  api_type            = "http" # graphql, http, soap, and websocket
  protocols           = ["http", "https"]
  service_url         = "https://conferenceapi.azurewebsites.net"

  import {
    content_format = "swagger-link-json" # openapi, openapi+json, openapi+json-link, openapi-link, swagger-json, swagger-link-json, wadl-link-json, wadl-xml, wsdl and wsdl-link.
    content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  }
}

resource "azurerm_api_management_api_policy" "api-conference-policy" {
  api_name            = azurerm_api_management_api.api-conference.name
  api_management_name = azurerm_api_management_api.api-conference.api_management_name
  resource_group_name = azurerm_api_management_api.api-conference.resource_group_name

  xml_content = <<XML
<policies>
    <inbound>
        <rate-limit-by-key calls="3" renewal-period="15" counter-key="@(context.Subscription.Id)" />
        <base />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
        <set-header name="X-Powered-By" exists-action="delete" />
        <set-header name="X-AspNet-Version" exists-action="delete" />
        <redirect-content-urls />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_product" "product" {
  product_id            = "product-01"
  api_management_name   = azurerm_api_management.apim.name
  resource_group_name   = azurerm_api_management.apim.resource_group_name
  display_name          = "Product 01"
  subscription_required = true
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_product_api" "product-api" {
  api_name            = azurerm_api_management_api.api-conference.name
  product_id          = azurerm_api_management_product.product.product_id
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_api_management.apim.resource_group_name
}

# moved {
#   from = azurerm_api_management_api.api
#   to  = azurerm_api_management_api.api-conference
# }

resource "azurerm_api_management_logger" "apim-logger" {
  name                = "apim-logger"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_api_management.apim.resource_group_name
  resource_id         = azurerm_application_insights.app_insights.id

  application_insights {
    instrumentation_key = azurerm_application_insights.app_insights.instrumentation_key
  }
}
