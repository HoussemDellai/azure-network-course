resource "azurerm_app_service_managed_certificate" "managed_certificate" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_domain_binding.id
}

resource "azurerm_app_service_certificate_binding" "custom_domain_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_domain_binding.id
  certificate_id      = azurerm_app_service_managed_certificate.managed_certificate.id
  ssl_state           = "SniEnabled"

  depends_on = [azurerm_dns_txt_record.txt_record]
}