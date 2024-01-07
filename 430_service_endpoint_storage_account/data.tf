data "azurerm_client_config" "current" {}

data "http" "machine_ip" {
  url = "http://ifconf.me"

  request_headers = {
    Accept = "application/json"
  }

  lifecycle {
    postcondition {
      condition     = contains([200], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

locals {
  machine_ip = replace(data.http.machine_ip.response_body, "\n", "")
}

data "azurerm_storage_account_blob_container_sas" "blob_sas" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  container_name    = azurerm_storage_container.container.name
  https_only        = true

  #   ip_address = "168.1.5.65"
  start  = "2023-12-24"
  expiry = "2030-01-01"

  permissions {
    read   = true
    add    = true
    create = false
    write  = false
    delete = true
    list   = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
  content_type        = "application/json"
}
