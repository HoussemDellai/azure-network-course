## Create a random string
## 
resource "random_string" "unique" {
  length      = 5
  min_numeric = 5
  numeric     = true
  special     = false
  lower       = true
  upper       = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-foundry-${random_string.unique.result}"
  location = "swedencentral"
}

resource "azapi_resource" "ai_foundry" {
  type                      = "Microsoft.CognitiveServices/accounts@2025-06-01"
  name                      = "foundry-${random_string.unique.result}"
  parent_id                 = azurerm_resource_group.rg.id
  location                  = azurerm_resource_group.rg.location
  schema_validation_enabled = false

  body = {
    kind = "AIServices"
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      disableLocalAuth = false
      allowProjectManagement = true
      customSubDomainName = "foundry-${random_string.unique.result}"
      publicNetworkAccess = "Enabled"
    }
  }
}

resource "azapi_resource" "ai_foundry_project" {
  type                      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name                      = "project-${random_string.unique.result}"
  parent_id                 = azapi_resource.ai_foundry.id
  location                  = azurerm_resource_group.rg.location
  schema_validation_enabled = false

  body = {
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      displayName = "project"
      description = "My first project"
    }
  }
}