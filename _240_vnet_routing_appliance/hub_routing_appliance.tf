# create vnet routing appliance in subnet VirtualNetworkApplianceSubnet using azapi provider
# https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworkappliances?pivots=deployment-language-terraform

resource "azapi_resource" "hub_routing_appliance" {
  type                      = "Microsoft.Network/virtualNetworkAppliances@2026-05-01"
  name                      = "hub-routing-appliance"
  location                  = azurerm_resource_group.rg_hub.location
  parent_id                 = azurerm_resource_group.rg_hub.id
  schema_validation_enabled = false

  body = {
    properties = {
      bandwidthInGbps         = 10
      privateIPAddressVersion = "IPv4"

      subnet = {
        id = azurerm_subnet.snet_routing_appliance.id
      }
    }
  }

  response_export_values = ["*"]
}

output "routing_appliance_ip" {
  value = azapi_resource.hub_routing_appliance.output.properties.ipConfigurations.0.properties.privateIPAddress
}