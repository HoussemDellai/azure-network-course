# Azure Functions profile.ps1
#
# This profile.ps1 will get executed every "cold start" of your Function App.
# "cold start" occurs when:
#
# * A Function App starts up for the very first time
# * A Function App starts up after being de-allocated due to inactivity
#
# You can define helper functions, run commands, or specify environment variables
# NOTE: any variables defined that are not environment variables will get reset after the first execution

# Import-Module Az
Import-Module Az.Accounts
# Import-Module Az.Network

# Authenticate with Azure PowerShell using MSI.
# Remove this if you are not planning on using MSI or Azure PowerShell.
if ($env:MSI_SECRET) {
    Disable-AzContextAutosave -Scope Process | Out-Null
    Connect-AzAccount -Identity
}

# Uncomment the next line to enable legacy AzureRm alias in Azure PowerShell.
# Enable-AzureRmAlias

# You can also define functions or aliases that can be referenced in any of your PowerShell functions.

# function Stop-AzFirewall {
#     param (
#         [string]$FirewallName = "firewall",
#         [string]$ResourceGroupName = "rg-vpn-gateway-p2s-815-dev"
#     )

#     $azfw = Get-AzFirewall -Name $FirewallName -ResourceGroupName $ResourceGroupName
#     $azfw.Deallocate()
#     Set-AzFirewall -AzureFirewall $azfw
# }

# Stop-AzFirewall