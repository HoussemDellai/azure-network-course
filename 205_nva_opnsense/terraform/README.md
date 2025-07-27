# OPNsense Firewall Terraform Deployment

This Terraform configuration deploys OPNsense firewall in Azure with support for two deployment scenarios:

1. **TwoNics**: Single OPNsense VM with two network interfaces
2. **Active-Active**: Two OPNsense VMs in HA mode with load balancers

## Converted from ARM Template

This Terraform configuration is converted from the original ARM template `main.json` and maintains the same functionality and deployment options.

## Prerequisites

1. **Terraform Installation**: If Terraform is not installed, you can install it using winget:
   ```powershell
   winget install HashiCorp.Terraform
   ```

2. **Azure CLI**: Ensure you're authenticated with Azure CLI:
   ```powershell
   az login
   ```

3. **Resource Group**: Create a resource group or ensure you have an existing one to deploy into.

## Quick Start

1. **Clone and Navigate**:
   ```powershell
   cd d:\projects\azure-network-course\205_nva_opnsense\terraform
   ```

2. **Configure Variables**:
   ```powershell
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```

3. **Initialize Terraform**:
   ```powershell
   terraform init
   ```

4. **Validate Configuration**:
   ```powershell
   terraform validate
   ```

5. **Plan Deployment**:
   ```powershell
   terraform plan
   ```

6. **Deploy Infrastructure**:
   ```powershell
   terraform apply -auto-approve
   ```

## Configuration Options

### Required Variables

- `resource_group_name`: Name of the Azure resource group
- `virtual_machine_name`: Name for the OPNsense VM(s)

### Deployment Scenarios

#### TwoNics (Default)
- Single OPNsense VM with two network interfaces
- Suitable for basic firewall functionality
- Lower cost option

#### Active-Active
- Two OPNsense VMs in high availability configuration
- External and internal load balancers
- Higher availability and redundancy
- Higher cost due to multiple VMs and load balancers

### Network Configuration

- **New VNet**: Creates a new virtual network with specified CIDR blocks
- **Existing VNet**: Uses an existing virtual network and subnets

### Optional Components

- **Windows VM**: Deploy a Windows 11 client VM for testing
- **Custom Subnets**: Configure custom subnet CIDR blocks

## Deployment Architecture

### TwoNics Scenario
```
Internet
    │
    ├─ Public IP
    │
    ├─ OPNsense VM
    │   ├─ Untrusted NIC (Public Subnet)
    │   └─ Trusted NIC (Private Subnet)
    │
    └─ [Optional] Windows VM (Windows Subnet)
```

### Active-Active Scenario
```
Internet
    │
    ├─ External Load Balancer
    │   ├─ OPNsense Primary VM
    │   └─ OPNsense Secondary VM
    │
    ├─ Internal Load Balancer
    │   ├─ OPNsense Primary VM (Trusted NIC)
    │   └─ OPNsense Secondary VM (Trusted NIC)
    │
    └─ [Optional] Windows VM (Windows Subnet)
```

## Post-Deployment

After successful deployment, you can access:

### TwoNics Scenario
- **OPNsense Management**: `https://<public_ip>`

### Active-Active Scenario
- **Primary OPNsense**: `https://<public_ip>:50443`
- **Secondary OPNsense**: `https://<public_ip>:50444`

### Windows VM (if deployed)
- **RDP Access**: Use the public IP address output
- **Credentials**: As specified in `win_username` and `win_password`

## Important Notes

1. **Default Credentials**: The OPNsense VMs use temporary credentials that should be changed after first login
2. **Firewall Rules**: Default NSG rules allow SSH, HTTP, and HTTPS. Customize as needed
3. **Security**: Change default passwords and configure proper firewall rules for production use
4. **Cost**: Active-Active scenario incurs higher costs due to multiple VMs and load balancers

## Troubleshooting

1. **Terraform Validate**: Always run `terraform validate` before `terraform plan`
2. **State Management**: Terraform state is stored locally by default. Consider remote state for production
3. **Resource Cleanup**: Use `terraform destroy` to remove all created resources

## Terraform Best Practices

This configuration follows Terraform best practices:
- Modular structure with reusable modules
- Proper variable validation
- Comprehensive outputs
- Resource tagging for organization
- Conditional resource creation based on scenarios

## Azure Portal Access

After successful deployment, you can view and manage your resources in the Azure Portal:
[Azure Portal](https://portal.azure.com)

Navigate to your resource group to see all deployed resources including VMs, load balancers, network interfaces, and security groups.
