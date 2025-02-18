# IMPORTANT NOTE on regional virtual network integration:
# The AzureRM Terraform provider provides regional virtual network integration via 
# the standalone resource app_service_virtual_network_swift_connection 
# and in-line within this resource using the virtual_network_subnet_id property.
# You cannot use both methods simultaneously. 
# If the virtual network is set via the resource app_service_virtual_network_swift_connection 
# then ignore_changes should be used in the web app configuration.
# Src: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#virtual_network_subnet_id-1

# resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegration" {
#   app_service_id  = azurerm_linux_web_app.frontend.id
#   subnet_id       = azurerm_subnet.snet-integration.id
# }