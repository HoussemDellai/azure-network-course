param($myTimer)

function run {
    Write-Host "Timer trigger function executed at: $(Get-Date)"
    # Add your logic here
} 

run

function Stop-AzFirewall {
    # param (
    #     [string]$FirewallName = "firewall",
    #     [string]$ResourceGroupName = "rg-vpn-gateway-p2s-815-dev"
    # )

    $FirewallName = $env:Firewall_NAME
    $ResourceGroupName = $env:FIREWALL_RESOURCE_GROUP

    # authenticate to Azure using SystemAssigned Identity
    # Connect-AzAccount -Identity

    $azfw = Get-AzFirewall -Name $FirewallName -ResourceGroupName $ResourceGroupName
   
    Write-Host "Stopping Azure Firewall: $($azfw.Name) in Resource Group: $($azfw.ResourceGroupName)"
   
    $azfw.Deallocate()
    Set-AzFirewall -AzureFirewall $azfw
   
    Write-Host "Azure Firewall stopped successfully."
}

Stop-AzFirewall