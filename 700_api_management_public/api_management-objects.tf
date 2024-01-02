# resource "azurerm_api_management_product" "product-conference" {
#   product_id            = "product-conference"
#   api_management_name   = azurerm_api_management.apim.name
#   resource_group_name   = azurerm_api_management.apim.resource_group_name
#   display_name          = "Product Conference"
#   subscription_required = true
#   approval_required     = false
#   published             = true
# }

# resource "azurerm_api_management_product_api" "product-api" {
#   api_name            = azurerm_api_management_api.api-conference.name
#   product_id          = azurerm_api_management_product.product-conference.product_id
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name = azurerm_api_management.apim.resource_group_name
# }

# resource "azurerm_api_management_user" "user" {
#   count               = 0
#   user_id             = "apimdevuserhoussem"
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name = azurerm_api_management.apim.resource_group_name
#   first_name          = "Houssem"
#   last_name           = "Dellai"
#   email               = "houssem.dellai@gmail.com"
#   state               = "active" # active, blocked and pending
#   confirmation        = "invite" # invite or signup
#   password            = "P@ssw0rd!"
# }

# resource "azurerm_api_management_subscription" "subscription-conference" {
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name = azurerm_api_management.apim.resource_group_name
#   user_id             = azurerm_api_management_user.user.id
#   product_id          = azurerm_api_management_product.product-conference.id
#   display_name        = "Subscription for Conference API"
#   state               = "active" # active, cancelled, expired, rejected, submitted and suspended. Defaults to submitted
# }
