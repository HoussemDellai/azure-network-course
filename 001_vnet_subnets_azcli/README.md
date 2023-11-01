# Creating Virtual Network and Subnets using Azure CLI

Create resource group

```bash
az group create --name rg-demo-vnet --location westeurope
```

Create virtual network

```bash
az network vnet create --resource-group rg-demo-vnet --name vnet-demo --address-prefixes ["10.0.0.0/16"]
```

Create subnet for frontend web servers

```bash
az network vnet subnet create -g rg-demo-vnet --vnet-name vnet-demo -n subnet-frontend-servers --address-prefixes ["10.0.0.0/24"]
```

Create subnet for backend servers

```bash
az network vnet subnet create -g rg-demo-vnet --vnet-name vnet-demo -n subnet-backend-servers --address-prefixes ["10.0.1.0/24"]
```

Show subnet CIDR ranges

```bash
az network vnet subnet list -g rg-demo-vnet --vnet-name vnet-demo --query "[].{SubnetName:name, AddressPrefix:addressPrefix}" --output table
# SubnetName               AddressPrefix
# -----------------------  ---------------
# subnet-frontend-servers  10.0.0.0/24
# subnet-backend-servers   10.0.1.0/24
```

Cleanup resources

```bash
az group delete --name rg-demo-vnet --yes --no-wait
```