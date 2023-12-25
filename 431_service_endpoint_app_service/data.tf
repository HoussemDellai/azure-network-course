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
  machine_ip      = replace(data.http.machine_ip.response_body, "\n", "")
  machine_ip_cidr = "${local.machine_ip}/32"
}
