resource "azurerm_api_management_api" "api-conference" {
  name                  = "api-conference"
  resource_group_name   = azurerm_api_management.apim.resource_group_name
  api_management_name   = azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "Conference API"
  path                  = "conference"
  api_type              = "http" # graphql, http, soap, and websocket
  protocols             = ["http", "https"]
  service_url           = "https://conferenceapi.azurewebsites.net"
  subscription_required = true

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
