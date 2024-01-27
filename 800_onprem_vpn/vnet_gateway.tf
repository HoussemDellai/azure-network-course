resource "azurerm_public_ip" "pip-vnet-gateway" {
  name                = "pip-vnet-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vnet-gateway" {
  name                = "vnet-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn" # ExpressRoute
  vpn_type = "RouteBased" # PolicyBased

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2" # Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip-vnet-gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-gateway.id
  }

  vpn_client_configuration {
    address_space = ["10.1.0.0/24"]

    root_certificate {
      name = "P2SRootCert800"
    #   public_cert_data = filebase64("./certs/P2SRootCert800.cer")
      public_cert_data = <<CERT
MIIC7TCCAdWgAwIBAgIQNkgiCmzvDLpIQ8I5RT9zkzANBgkqhkiG9w0BAQsFADAZ
MRcwFQYDVQQDDA5QMlNSb290Q2VydDgwMDAeFw0yNDAxMjcwODE2MjdaFw0yNjAx
MjcwODI2MjdaMBkxFzAVBgNVBAMMDlAyU1Jvb3RDZXJ0ODAwMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmyfFE0FvBMKMBU2uGFG/Drxnn8irLA3tmwN5
+qvhC1XneEVXShmaESjN/ETElL6u86EK2UwDUBdkcT5Gl3SRJu61ZND1SEsBNIC1
FC9bMFMDpP4oVaaoQLxTQT2n8vW0oXr4srAOTNzPkUnH0rir/5GoVtEbrXyyOn79
dmj6/hK7kkAIpO3OIj1oVEblG0XVV0mildm72ue4Jxw6zxulcvxCNGYnOyh+SjuS
DdC6puqWVoCIpTCMnEPOPiaUwppIDlH1xUfD62gumnAkTzNymj9C/3orDRWqhiTd
/nTdjSeySyzlWoregkG/hFYMWShnf+uCxXfrkJxjiFMO1oW0WQIDAQABozEwLzAO
BgNVHQ8BAf8EBAMCAgQwHQYDVR0OBBYEFMax7OnaILaPu51P4Jn8r8oQdhCTMA0G
CSqGSIb3DQEBCwUAA4IBAQBrMCaq26XUWCkkGtpw6Imw7Sg5LvkARhYP35OOIAQA
O/BN/o/UWwJCdO1c4CG3oXpAxNXcu4U62FpwQGhASB3aGQwolQQ64hOx3ax2insT
b/wwN5fH6Qz9sxRkG2tKJOyT5ikaE5rxGIciOGovNWikf/tIBTolwOoLmBAeDXXS
ifyOqxKWJmhft76MuhXsZ/nBirVAjXPxQAN5R2caaU+wnmDVcNS/dqEWqRiiWj+4
VseTSQkrH0DvOWXbjp4aGiZxh+sUZvSMCzHZ9/cT26jfcqwecbi8gdJ6T+kuluk6
0/g2BuU1zKvngP8o/5/25VT47+ts3F4VeapFnm0QzOOg
CERT
    }

    # revoked_certificate {
    #   name       = "Verizon-Global-Root-CA"
    #   thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
    # }
  }
}
