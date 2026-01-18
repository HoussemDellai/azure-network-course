resource "azapi_resource" "foundry_project_capability_host" {
  # depends_on = [
  #   azapi_resource.conn_aisearch,
  #   azapi_resource.conn_cosmosdb,
  #   azapi_resource.conn_storage,
  #   time_sleep.wait_rbac
  # ]
  type                      = "Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-10-01-preview"
  name                      = "foundry-project-capability-host"
  parent_id                 = azurerm_cognitive_account_project.project.id
  schema_validation_enabled = false

  body = {
    properties = {
      capabilityHostKind             = "Agents"
      enablePublicHostingEnvironment = true
      # vectorStoreConnections = [
      #   azapi_resource.ai_search.name
      # ]
      # storageConnections = [
      #   azurerm_storage_account.storage_account.name
      # ]
      # threadStorageConnections = [
      #   azurerm_cosmosdb_account.cosmosdb.name
      # ]
    }
  }
}
