resource "azurerm_storage_account" "sa" {
  name                     = "storagefunction${var.prefix}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-functions"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "function-linux-container" {
  name                        = "function-linux-container-${random_string.random.result}-${var.prefix}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  service_plan_id             = azurerm_service_plan.plan.id
  https_only                  = true
  storage_account_name        = azurerm_storage_account.sa.name
  storage_account_access_key  = azurerm_storage_account.sa.primary_access_key
  functions_extension_version = "~4"

  site_config {
    always_on = true
    application_stack {
      docker {
        registry_url = "https://index.docker.io"
        image_name   = "houssemdocker/backend-api"
        image_tag    = "1.0"
      }
    }

    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.subnet-apim.id
    }
  }
}
