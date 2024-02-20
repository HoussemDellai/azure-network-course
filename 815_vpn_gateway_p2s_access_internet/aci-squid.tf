resource "azurerm_container_group" "aci-squid" {
  name                = "aci-squid"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "squid"
    image  = "ubuntu/squid:5.2-22.04_beta"
    cpu    = "1.0"
    memory = "1.0"

    commands = [
      # "/bin/sh",
      "/bin/bash",
      "-c",
    "sed -i '/http_access deny all/i acl localnet src 176.177.25.47' /etc/squid/squid.conf; i=0; while true; do echo 'This is demo log $i: $(date)'; i=$((i+1)); sleep 1; done"]
    # "apt update -y; apt install squid; sed -i '/http_access deny all/i acl localnet src 176.177.25.47' /etc/squid/squid.conf" ]
    # "ls /etc/" ]
    # "sed -i '/http_access deny all/i acl localnet src 176.177.25.47' /etc/squid/squid.conf" ]

    # cat /etc/squid/squid.conf | grep 176

    ports {
      port     = 3128
      protocol = "TCP"
    }
  }

  exposed_port = [
    {
      port     = 3128
      protocol = "TCP"
  }]
}

output "aci-squid-public_ip" {
  value = azurerm_container_group.aci-squid.ip_address
}
