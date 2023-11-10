# cd into the current directory

terraform init

terraform plan -out tfplan

terraform apply tfplan

az vm list --query [].id

# Initiate the connection from the command line.
# Make sure to replace the value with your own VM ID.

# Connect to the Linux VM using SSH.

az network bastion ssh -n bastion-host -g rg-bastion --auth-type password --username azureuser --target-resource-id "/subscriptions/38977b70-47bf-4da5-a492-88712fce8725/resourceGroups/RG-VM-LINUX/providers/Microsoft.Compute/virtualMachines/vm-linux"

# Connect to the Windows VM using RDP.

az network bastion rdp -n bastion-host -g rg-bastion --target-resource-id "/subscriptions/38977b70-47bf-4da5-a492-88712fce8725/resourceGroups/RG-VM-WINDOWS/providers/Microsoft.Compute/virtualMachines/vm-windows"