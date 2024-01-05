output "appgateway_ip" {
  value = azurerm_public_ip.pip-appgateway.ip_address
}

output "appservice_domain_name" {
  value = module.appservice_domain.appservice_domain_name
}

output "app_service_domain_id" {
  value = module.appservice_domain.app_service_domain_id
}