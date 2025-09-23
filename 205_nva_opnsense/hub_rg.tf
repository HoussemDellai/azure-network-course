resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-nva-opnsense-${var.prefix}"
  location = "swedencentral" # "swedencentral" #  # "swedencentral"

  tags = {
    Cost-Control     = "Ignore"
    Security-Control = "Ignore"
  }
}
