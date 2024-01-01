resource "azurerm_api_management_user" "user" {
  user_id             = "apimdevuserhoussem"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_api_management.apim.resource_group_name
  first_name          = "Houssem"
  last_name           = "Dellai"
  email               = "houssem.dellai@gmail.com"
  state               = "active" # active, blocked and pending
  confirmation        = "invite" # invite or signup
  password            = "P@ssw0rd!"
}
