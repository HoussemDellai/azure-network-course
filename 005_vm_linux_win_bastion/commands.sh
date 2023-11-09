# cd into the current directory

terraform init

terraform plan -out tfplan

terraform apply tfplan

az vm list --query [].id

# Initiate the connection from the command line.
# Make sure to replace the value with your own VM ID.

# Connect to the Linux VM using SSH.

az network bastion ssh -n bastion-host -g rg-bastion --target-resource-id /subscriptions/xxx/resourceGroups/rg-vm-linux/providers/Microsoft.Compute/virtualMachines/vm-linux

# Connect to the Windows VM using RDP.

az network bastion rdp -n bastion-host -g rg-bastion --target-resource-id /subscriptions/xxx/resourceGroups/rg-vm-windows/providers/Microsoft.Compute/virtualMachines/vm-windows