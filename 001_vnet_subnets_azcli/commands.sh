# create resource group
az group create --name rg-demo-vnet --location westeurope

# create virtual network
az network vnet create --resource-group rg-demo-vnet --name vnet-demo --address-prefixes ["10.0.0.0/16"]

# create subnet for frontend web servers
az network vnet subnet create -g rg-demo-vnet --vnet-name vnet-demo -n subnet-frontend-servers --address-prefixes ["10.0.0.0/24"]

# create subnet for backend servers
az network vnet subnet create -g rg-demo-vnet --vnet-name vnet-demo -n subnet-backend-servers --address-prefixes ["10.0.1.0/24"]

# show subnet CIDR ranges
az network vnet subnet list -g rg-demo-vnet --vnet-name vnet-demo --query "[].{SubnetName:name, AddressPrefix:addressPrefix}" --output table
# SubnetName               AddressPrefix
# -----------------------  ---------------
# subnet-frontend-servers  10.0.0.0/24
# subnet-backend-servers   10.0.1.0/24

# cleanup resources
az group delete --name rg-demo-vnet --yes --no-wait