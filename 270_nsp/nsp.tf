resource "azapi_resource" "networkSecurityPerimeter" {
  type      = "Microsoft.Network/networkSecurityPerimeters@2023-07-01-preview"
  parent_id = azurerm_resource_group.rg.id
  name      = "nsp-${var.prefix}"
  location  = azurerm_resource_group.rg.location
  body = {
    properties = {}
  }
}

resource "azapi_resource" "nsp_profile" {
  type      = "Microsoft.Network/networkSecurityPerimeters/profiles@2023-07-01-preview"
  parent_id = azapi_resource.networkSecurityPerimeter.id
  name      = "nsp-profile"
  location  = azurerm_resource_group.rg.location
  body = {
    properties = {}
  }
}

resource "azapi_resource" "nsp_access_rule_inbound" {
  type      = "Microsoft.Network/networkSecurityPerimeters/profiles/accessRules@2023-07-01-preview"
  parent_id = azapi_resource.nsp_profile.id
  name      = "nsp-access-rule-inbound"
  location  = azurerm_resource_group.rg.location
  body = {
    properties = {
      addressPrefixes           = ["*"] # ["100.10.0.0/16"]
      direction                 = "Inbound"
      emailAddresses            = []
      fullyQualifiedDomainNames = []
      phoneNumbers              = []
      subscriptions             = []
    }
  }
}

resource "azapi_resource" "nsp_access_rule_outbound" {
  type      = "Microsoft.Network/networkSecurityPerimeters/profiles/accessRules@2023-07-01-preview"
  parent_id = azapi_resource.nsp_profile.id
  name      = "nsp_access_rule_outbound"
  location  = azurerm_resource_group.rg.location
  body = {
    properties = {
      addressPrefixes           = []
      direction                 = "Outbound"
      emailAddresses            = []
      fullyQualifiedDomainNames = ["contoso.com"]
      phoneNumbers              = []
      subscriptions             = []
    }
  }
}

resource "azapi_resource" "nsp_resource_association_keyvault" {
  type      = "Microsoft.Network/networkSecurityPerimeters/resourceAssociations@2023-07-01-preview"
  parent_id = azapi_resource.networkSecurityPerimeter.id
  name      = "nsp-resource-association-keyvault"
  location  = azurerm_resource_group.rg.location
  body = {
    properties = {
      accessMode = "Learning" # "Enforced" # 
      privateLinkResource = {
        id = azurerm_key_vault.keyvault.id
      }
      profile = {
        id = azapi_resource.nsp_profile.id
      }
    }
  }
}