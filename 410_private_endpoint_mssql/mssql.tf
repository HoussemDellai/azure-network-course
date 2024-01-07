resource "azurerm_mssql_server" "mssql-server" {
  name                          = "sqlserver-${random_string.random.result}-410"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  version                       = "12.0"
  administrator_login           = "azureuser"
  administrator_login_password  = "@Aa123456789"
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "database" {
  name           = "products-db"
  server_id      = azurerm_mssql_server.mssql-server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "Basic" # GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100
  zone_redundant = false
}

# works when public_network_access_enabled = true
# resource "azurerm_mssql_firewall_rule" "firewall-rule" {
#   name             = "firewall-rule"
#   server_id        = azurerm_mssql_server.mssql-server.id
#   start_ip_address = local.machine_ip
#   end_ip_address   = local.machine_ip
# }

# data "http" "machine_ip" {
#   url = "http://ifconf.me"

#   request_headers = {
#     Accept = "application/json"
#   }
# }

# locals {
#   machine_ip = replace(data.http.machine_ip.response_body, "\n", "")
# }