resource "azurerm_container_app_environment" "env" {
  name                = "aca-environment"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_app" "app" {
  name                         = "aca-app-proxy"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 3
    container {
      name    = "proxy"
      image   = "docker.io/mitmproxy/mitmproxy:latest"
      command = ["/bin/bash"]
      args    = ["-c", "mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 80 --set block_global=false"]
      # args    = ["-c", "mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false"]
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80 # 8081
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
