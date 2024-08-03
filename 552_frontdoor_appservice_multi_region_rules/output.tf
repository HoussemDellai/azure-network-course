output "frontdoor_endpoint_url" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}

output "appservice_url_region1" {
  value = azurerm_linux_web_app.region1.default_hostname
}

output "appservice_url_region2" {
  value = azurerm_linux_web_app.region2.default_hostname
}

output "appservice_url_region3" {
  value = azurerm_linux_web_app.region3.default_hostname
}

output "vm_region1_public_ip" {
  value = module.vm-region1.vm_public_ip
}

output "vm_region2_public_ip" {
  value = module.vm-region2.vm_public_ip
}

output "vm_region3_public_ip" {
  value = module.vm-region3.vm_public_ip
}