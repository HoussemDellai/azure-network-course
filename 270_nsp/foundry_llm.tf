# resource "azurerm_cognitive_deployment" "gpt_52" {
#   name                 = "gpt-5.2"
#   cognitive_account_id = azurerm_cognitive_account.foundry.id

#   sku {
#     name     = "GlobalStandard" # "Standard" # DataZoneStandard, GlobalBatch, GlobalStandard and ProvisionedManaged
#     capacity = 10
#   }

#   model {
#     format  = "OpenAI"
#     name    = "gpt-5.2"
#     version = "2025-12-11"
#   }
# }

resource "azurerm_cognitive_deployment" "gpt_4o_mini" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  sku {
    name     = "GlobalStandard" # "Standard" # DataZoneStandard, GlobalBatch, GlobalStandard and ProvisionedManaged
    capacity = 20
  }

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }
}

output "llm_model_deployment_name" {
  value = azurerm_cognitive_deployment.gpt_4o_mini.name
}