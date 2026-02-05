# installs OPNsense using a custom script extension

locals {
  trusted_ipv4_prefixes = [for p in azurerm_subnet.snet-trusted.address_prefixes : p if !can(regex(":", p))]
  opnsense_version      = "26.1" # "25.7" # check here for latest versions: https://docs.opnsense.org/releases.html
  trusted_gw_ip         = cidrhost(local.trusted_ipv4_prefixes[0], 1)
  opnsense_pip          = azurerm_public_ip.pip-vm-nva.ip_address
}

resource "azurerm_virtual_machine_extension" "cslinux-install-opnsense" {
  name                 = "cslinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm-nva.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"
  settings             = <<SETTINGS
    {
      "fileUris": [
        "https://raw.githubusercontent.com/HoussemDellai/azure-network-course/refs/heads/main/205_nva_opnsense/scripts/configureopnsense.sh"
      ],
      "commandToExecute": "sh configureopnsense.sh 'https://raw.githubusercontent.com/HoussemDellai/azure-network-course/refs/heads/main/205_nva_opnsense/scripts/' '${local.opnsense_version}' '${local.trusted_gw_ip}' '${local.opnsense_pip}'"
    }
    SETTINGS
}

# resource "azurerm_virtual_machine_run_command" "run_command_install_opnsense" {
#   name               = "run-command-install-opnsense"
#   location           = azurerm_linux_virtual_machine.vm-nva.location
#   virtual_machine_id = azurerm_linux_virtual_machine.vm-nva.id

#   source {
#     script = "${file("./scripts/configureopnsense.sh")} '${local.opnsense_version}' '${local.trusted_gw_ip}' '${local.opnsense_pip}'"
#   }
# }