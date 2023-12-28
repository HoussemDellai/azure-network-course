resource "azurerm_storage_account" "sa" {
  name                     = "storagefunction700"
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
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "linux-function-app" {
  name                = "function-linux-700"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name        = azurerm_storage_account.sa.name
  storage_account_access_key  = azurerm_storage_account.sa.primary_access_key
  service_plan_id             = azurerm_service_plan.plan.id
  functions_extension_version = "~4"
  https_only                  = true

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "",
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet",
  }


  site_config {
    use_32_bit_worker = false

    application_stack {
      dotnet_version = "8.0"
    }

    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.subnet-backend.id
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}

resource "azurerm_linux_function_app" "function-linux-container" {
  name                        = "function-linux-container-700"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  service_plan_id             = azurerm_service_plan.plan.id
  https_only                  = true
  storage_account_name        = azurerm_storage_account.sa.name
  storage_account_access_key  = azurerm_storage_account.sa.primary_access_key
#   functions_extension_version = "~4"

#   app_settings = {
#     # "WEBSITE_RUN_FROM_PACKAGE" = "",
#     # "FUNCTIONS_WORKER_RUNTIME" = "dotnet",
#     "WEBSITES_PORT"            = 3500
#   }

  site_config {
    # use_32_bit_worker = false
    always_on = true
    application_stack {
      docker {
        registry_url = "https://registry.hub.docker.com"
        image_name   = "houssemdocker/backend-api"
        image_tag    = "1.0"
        # registry_url = "ghcr.io"
        # image_name   = "houssemdellai/containerapps-album-backend"
        # image_tag    = "v1"
      }
    }

    # ip_restriction {
    #   virtual_network_subnet_id = azurerm_subnet.subnet-backend.id
    # }
  }

#   lifecycle {
#     ignore_changes = [
#       app_settings["WEBSITE_RUN_FROM_PACKAGE"],
#     ]
#   }
}
