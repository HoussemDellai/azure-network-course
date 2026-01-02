resource "azurerm_cognitive_deployment" "gpt_52" {
  name                 = "gpt-5.2"
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  sku {
    name     = "GlobalStandard" # "Standard" # DataZoneStandard, GlobalBatch, GlobalStandard and ProvisionedManaged
    capacity = 10
  }

  model {
    format  = "OpenAI"
    name    = "gpt-5.2"
    version = "2025-12-11"
  }
}

output "model_deployment_name" {
  value = azurerm_cognitive_deployment.gpt_52.name
}