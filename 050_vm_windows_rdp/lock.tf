# resource "azurerm_management_lock" "lock-rg" {
#   name       = "do-not-delete"
#   scope      = azurerm_resource_group.rg.id
#   lock_level = "CanNotDelete"
#   notes      = "Items can't be deleted in this rg!"
# }