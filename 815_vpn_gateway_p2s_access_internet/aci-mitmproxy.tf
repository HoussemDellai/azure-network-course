resource "azurerm_container_group" "aci-mitmproxy" {
  name                = "aci-mitmproxy"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "mitmproxy"
    image  = "mitmproxy/mitmproxy:latest"
    cpu    = "1.0"
    memory = "1.0"

    commands = [
      "/bin/bash",
      "-c",
      "mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false"
    ]

    ports {
      port     = 8080
      protocol = "TCP"
    }

    ports {
      port     = 8081
      protocol = "TCP"
    }
  }

  exposed_port = [
    {
      port     = 8080
      protocol = "TCP"
    },
    {
      port     = 8081
      protocol = "TCP"
  }]
}

output "aci-mitmproxy-public_ip" {
  value = azurerm_container_group.aci-mitmproxy.ip_address
}
