data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                          = "kv-app-storage-${var.prefix}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  enable_rbac_authorization     = false
  public_network_access_enabled = false
}

resource "azurerm_key_vault_secret" "secret-storage-account-sas" {
  name         = "secret-storage-account-sas"
  value        = azurerm_storage_account.storage-account.primary_access_key
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [azurerm_key_vault_access_policy.access-policy-me]
}

resource "azurerm_key_vault_access_policy" "access-policy-appservice" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.frontend.identity.0.principal_id

  #   key_permissions = [
  #     "Get",
  #   ]

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_access_policy" "access-policy-me" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"
  ]
}

# Key Vault Secrets User
resource "azurerm_role_assignment" "role-key-vault-secrets-user" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.frontend.identity.0.principal_id
}
