# https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
# https://learn.microsoft.com/en-us/azure/storage/files/storage-files-configure-p2s-vpn-windows?tabs=azure-portal

# Generate and export certificates for point-to-site using PowerShell

# Create a self-signed root certificate

$RootCertName = "CN=P2SRootCert810"

$params = @{
    Type = 'Custom'
    Subject = $RootCertName
    KeySpec = 'Signature'
    KeyExportPolicy = 'Exportable'
    KeyUsage = 'CertSign'
    KeyUsageProperty = 'Sign'
    KeyLength = 2048
    HashAlgorithm = 'sha256'
    NotAfter = (Get-Date).AddMonths(24)
    CertStoreLocation = 'Cert:\CurrentUser\My'
}

$RootCert = New-SelfSignedCertificate @params

Export-Certificate -Cert $RootCert -FilePath ".\P2SRootCert810Encoded.cer" -NoClobber | Out-Null

certutil -encode ".\P2SRootCert810Encoded.cer" ".\P2SRootCert810.cer" | Out-Null

# Generate a client certificate
# Optional if you want to use the certificate in another machine

Get-ChildItem -Path "Cert:\CurrentUser\My"

$params = @{
    Type = 'Custom'
    Subject = 'CN=P2SClientCert810'
    DnsName = 'P2SClientCert810'
    KeySpec = 'Signature'
    KeyExportPolicy = 'Exportable'
    KeyLength = 2048
    HashAlgorithm = 'sha256'
    NotAfter = (Get-Date).AddMonths(18)
    CertStoreLocation = 'Cert:\CurrentUser\My'
    Signer = $RootCert
    TextExtension = @(
     '2.5.29.37={text}1.3.6.1.5.5.7.3.2')
}

$ClientCert = New-SelfSignedCertificate @params

# Export the root certificate public key (.cer)

$CertPwd = ConvertTo-SecureString -String "@Aa123456789" -Force -AsPlainText

Export-PfxCertificate -FilePath ".\P2SClientCert810.pfx" -Password $CertPwd -Cert $ClientCert | Out-Null