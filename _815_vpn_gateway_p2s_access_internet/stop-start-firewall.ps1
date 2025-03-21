# Stop the firewall

function Stop-AzFirewall {
    param (
        [string]$FirewallName = "firewall",
        [string]$ResourceGroupName = "rg-vpn-gateway-p2s-815-dev"
    )

    $azfw = Get-AzFirewall -Name $FirewallName -ResourceGroupName $ResourceGroupName
    $azfw.Deallocate()
    Set-AzFirewall -AzureFirewall $azfw
}

# $azfw = Get-AzFirewall -Name "firewall" -ResourceGroupName "rg-vpn-gateway-p2s-815-dev"

# $azfw.Deallocate()

# Set-AzFirewall -AzureFirewall $azfw

# Start the firewall

function Start-AzFirewall {
    param (
        [string]$FirewallName = "firewall",
        [string]$ResourceGroupName = "rg-vpn-gateway-p2s-815-dev",
        [string]$VnetName = "vnet-hub",
        [string]$PublicIpName = "pip-firewall"
    )

    $azfw = Get-AzFirewall -Name $FirewallName -ResourceGroupName $ResourceGroupName
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VnetName
    $publicip = Get-AzPublicIpAddress -Name $PublicIpName -ResourceGroupName $ResourceGroupName
    $azfw.Allocate($vnet, @($publicip))

    Set-AzFirewall -AzureFirewall $azfw
}

# $azfw = Get-AzFirewall -Name "firewall" -ResourceGroupName "rg-vpn-gateway-p2s-815-dev"
# $vnet = Get-AzVirtualNetwork -ResourceGroupName "rg-vpn-gateway-p2s-815-dev" -Name "vnet-hub"
# $publicip = Get-AzPublicIpAddress -Name "pip-firewall" -ResourceGroupName "rg-vpn-gateway-p2s-815-dev"
# $azfw.Allocate($vnet,@($publicip))

# Set-AzFirewall -AzureFirewall $azfw