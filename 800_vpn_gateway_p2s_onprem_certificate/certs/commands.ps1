# https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
# https://learn.microsoft.com/en-us/azure/storage/files/storage-files-configure-p2s-vpn-windows?tabs=azure-portal

# Generate and export certificates for point-to-site using PowerShell

# Create a self-signed root certificate

$RootCertName = "CN=P2SRootCert800"

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

Export-Certificate -Cert $RootCert -FilePath ".\P2SRootCert800Encoded.cer" -NoClobber | Out-Null

certutil -encode ".\P2SRootCert800Encoded.cer" ".\P2SRootCert800.cer" | Out-Null

# Generate a client certificate
# Optional if you want to use the certificate in another machine

Get-ChildItem -Path "Cert:\CurrentUser\My"
#    PSParentPath: Microsoft.PowerShell.Security\Certificate::CurrentUser\My
# Thumbprint                                Subject
# ----------                                -------
# F6A65B1743082B4C158CBB3BB1A47C9F34992E6E  CN=310b4f7b-e4f2-4287-97a4-96548ea39ea7
# AEA8AA79D47E305560188B73888C62942CBB654D  CN=P2SRootCert

# $cert = Get-ChildItem -Path "Cert:\CurrentUser\My\AEA8AA79D47E305560188B73888C62942CBB654D"

$params = @{
    Type = 'Custom'
    Subject = 'CN=P2SClientCert800'
    DnsName = 'P2SClientCert800'
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

Export-PfxCertificate -FilePath ".\P2SClientCert800.pfx" -Password $CertPwd -Cert $ClientCert | Out-Null