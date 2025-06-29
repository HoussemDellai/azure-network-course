resource "azurerm_service_plan" "app_service_plan" {
  name                = "plan-app-service"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "swedencentral"
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "frontend" {
  name                          = "app-service-${var.prefix}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.app_service_plan.id
  https_only                    = true
  virtual_network_subnet_id     = azurerm_subnet.snet-integration.id
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      docker_image_name   = "jelledruyts/inspectorgadget"
      docker_registry_url = "https://index.docker.io"
    }

    vnet_route_all_enabled = true # Currently, Linux applications that connect to private endpoints must be explicitly configured to route all traffic through the virtual network.
  }

  app_settings = { # use in case of integration with Key Vault
    "STORAGE_ACCOUNT_SAS_TOKEN" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.secret-storage-account-sas.versionless_id})"
  }

  storage_account {
    name         = "storage-account-connection"
    account_name = azurerm_storage_account.storage-account.name
    share_name   = azurerm_storage_share.file-share.name
    type         = "AzureFiles"
    mount_path   = "/mnt/files"
    access_key   = azurerm_key_vault_secret.secret-storage-account-sas.value
  }
}
