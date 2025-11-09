// Bicep template to create a lab setup for Private Endpoint routing tests

@secure()
param paramVmUsername string
@secure()
param paramVmPassword string

resource resHubVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: 'vnet-hub'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: 'vnet-spoke'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
}

resource resVNetPeeringHubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-10-01' = {
  name: 'hub-to-spoke'
  parent: resHubVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: resSpokeVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource resVNetPeeringSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-10-01' = {
  name: 'spoke-to-hub'
  parent: resSpokeVirtualNetwork
  properties: {
    remoteVirtualNetwork: {
      id: resHubVirtualNetwork.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource resAzureFirewallPublicIp 'Microsoft.Network/publicIPAddresses@2024-10-01' = {
  name: 'pip-azfw'
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2024-10-01' = {
  name: 'azfw-hub'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${resHubVirtualNetwork.id}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: resAzureFirewallPublicIp.id
          }
        }
      }
    ]
    networkRuleCollections: [
      {
        name: 'denyAllCollection'
        properties: {
          action: {
            type: 'Deny'
          }
          priority: 10000
          rules: [
            {
              name: 'denyAll'
              description: 'Deny all traffic'
              sourceAddresses: [
                '10.0.0.0/8'
              ]
              destinationAddresses: [
                '10.0.0.0/8'
              ]
              destinationPorts: [
                '*'
              ]
              protocols: [
                'Any'
              ]
            }
          ]
        }
      }
    ]
  }
}

resource resHubRouteTable 'Microsoft.Network/routeTables@2024-10-01' = {
  name: 'rt-hub'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'default'
        properties: {
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
          addressPrefix: '0.0.0.0/0'
        }
      }
    ]
  }
}

resource resSpokeRouteTable 'Microsoft.Network/routeTables@2024-10-01' = {
  name: 'rt-spoke'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'default'
        properties: {
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
          addressPrefix: '0.0.0.0/0'
        }
      }
    ]
  }
}

resource resHubSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-10-01' = {
  name: 'hub-subnet'
  parent: resHubVirtualNetwork
  properties: {
    addressPrefix: '10.0.10.0/24'
    routeTable: {
      id: resHubRouteTable.id
    }
  }
}

resource resSpokeSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-10-01' = {
  name: 'spoke-subnet'
  parent: resSpokeVirtualNetwork
  properties: {
    addressPrefix: '10.1.10.0/24'
    routeTable: {
      id: resSpokeRouteTable.id
    }
  }
}

resource resStorageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: 'st${uniqueString(resourceGroup().id)}'
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource resPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-10-01' = {
  name: 'pe-${resStorageAccount.name}'
  location: resourceGroup().location
  properties: {
    customNetworkInterfaceName: 'nic-pe-${resStorageAccount.name}'
    privateLinkServiceConnections: [
      {
        name: 'pe-${resStorageAccount.name}'
        properties: {
          privateLinkServiceId: resStorageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
    subnet: {
      id: resSpokeSubnet.id
    }
  }
}

resource resHubVirtualMachine 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: 'vm-hub'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    networkProfile: {
      networkApiVersion: '2022-11-01'
      networkInterfaceConfigurations: [
        {
          name: 'networkconfig1'
          properties: {
            ipConfigurations: [
              {
                name: 'ipconfig1'
                properties: {
                  subnet: {
                    id: resHubSubnet.id
                  }
                }
              }
            ]
          }
        }
      ]
    }
    osProfile: {
      adminUsername: paramVmUsername
      adminPassword: paramVmPassword
      computerName: 'vmhub'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
      }
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}