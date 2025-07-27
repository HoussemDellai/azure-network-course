# OPNsense Firewall Terraform Deployment

This Terraform configuration deploys OPNsense firewall(s) on Azure, converted from the original ARM template. It supports two deployment scenarios:

1. **TwoNics** - Single OPNsense firewall with two network interfaces
2. **Active-Active** - High Availability pair with load balancers

## Prerequisites

- Azure CLI or Azure PowerShell
- Terraform >= 1.0
- An Azure Resource Group

## Deployment Scenarios

### TwoNics (Single Firewall)
- Single OPNsense VM with untrusted and trusted interfaces
- Public IP directly attached to untrusted interface
- Suitable for development/testing environments

### Active-Active (High Availability)
- Two OPNsense VMs in active-active configuration
- External load balancer for inbound traffic
- Internal load balancer for outbound traffic from trusted networks
- Management access via NAT rules on external load balancer

## Quick Start

1. **Clone and navigate to the terraform directory**
   ```bash
   cd terraform/
   ```

2. **Copy the example variables file**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars with your values**
   ```hcl
   resource_group_name = "your-rg-name"
   virtual_network_name = "OPNsenseWAF-VNET"
   scenario_option = "TwoNics"  # or "Active-Active"
   ```

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Plan the deployment**
   ```bash
   terraform plan
   ```

6. **Apply the configuration**
   ```bash
   terraform apply
   ```

## Configuration Variables

### Required Variables
| Variable | Description | Example |
|----------|-------------|---------|
| `resource_group_name` | Name of the Azure Resource Group | `"opnsense-rg"` |
| `virtual_network_name` | Name of the virtual network | `"OPNsenseWAF-VNET"` |

### Optional Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `scenario_option` | Deployment scenario | `"TwoNics"` |
| `virtual_machine_size` | VM size for OPNsense | `"Standard_B2s"` |
| `deploy_windows` | Deploy Windows test VM | `false` |
| `public_ip_address_sku` | Public IP SKU | `"Standard"` |

### Network Configuration
| Variable | Description | Default |
|----------|-------------|---------|
| `vnet_address` | VNet address space | `["10.0.0.0/16"]` |
| `untrusted_subnet_cidr` | Untrusted subnet CIDR | `"10.0.1.0/24"` |
| `trusted_subnet_cidr` | Trusted subnet CIDR | `"10.0.2.0/24"` |
| `deploy_windows_subnet` | Windows VM subnet CIDR | `"10.0.3.0/24"` |

## Using Existing Virtual Networks

To deploy into an existing VNet:

1. Set `existing_virtual_network` to the existing VNet name
2. Specify the existing subnet names:
   ```hcl
   existing_virtual_network = "my-existing-vnet"
   existing_untrusted_subnet_name = "untrusted-subnet"
   existing_trusted_subnet_name = "trusted-subnet"
   existing_windows_subnet = "windows-subnet"  # if deploy_windows = true
   ```

## Post-Deployment

### Access OPNsense Web Interface

**TwoNics Scenario:**
- URL: `https://<public-ip>`
- Default credentials: `root/opnsense`

**Active-Active Scenario:**
- Primary: `https://<public-ip>:50443`
- Secondary: `https://<public-ip>:50444`
- Default credentials: `root/opnsense`

### Windows Test VM (if deployed)

- RDP: `mstsc /v:<windows-public-ip>`
- Username: Value of `win_username`
- Password: Value of `win_password`

## Outputs

After deployment, Terraform provides these outputs:

- `opnsense_public_ip` - Public IP of the firewall
- `opnsense_web_interface` - Web interface URL(s)
- `internal_load_balancer_ip` - Internal LB IP (Active-Active only)
- `windows_vm_public_ip` - Windows VM public IP (if deployed)
- `subnet_ids` - IDs of all subnets

## Architecture

### TwoNics Architecture
```
Internet
    |
[Public IP]
    |
[OPNsense VM]
    |
[Trusted Network]
    |
[Protected Resources]
```

### Active-Active Architecture
```
Internet
    |
[Public IP]
    |
[External Load Balancer]
   /              \
[OPNsense-1]   [OPNsense-2]
   \              /
[Internal Load Balancer]
    |
[Trusted Network]
    |
[Protected Resources]
```

## Troubleshooting

### Common Issues

1. **Resource Group Not Found**
   - Ensure the resource group exists before running Terraform
   - Verify you have proper permissions

2. **Subnet Conflicts**
   - Check that subnet CIDRs don't overlap
   - Ensure existing subnets exist when using existing VNet

3. **VM Size Not Available**
   - Verify the VM size is available in your region
   - Check Azure quotas

### Validation Commands

```bash
# Validate Terraform configuration
terraform validate

# Check what will be created/changed
terraform plan

# Show current state
terraform show

# List all resources
terraform state list
```

## Cleanup

To remove all deployed resources:

```bash
terraform destroy
```

## Differences from ARM Template

This Terraform version maintains the same functionality as the original ARM template but with these improvements:

- Simplified single-file configuration (no modules)
- Better variable validation
- Clearer resource naming
- Comprehensive outputs
- Easier customization through variables

## Security Considerations

- Change default OPNsense credentials after deployment
- Configure appropriate firewall rules
- Use strong passwords for Windows VM (if deployed)
- Review NSG rules for your security requirements
- Consider using Azure Key Vault for sensitive data

## Support

This configuration is based on the original ARM template for OPNsense deployment. For OPNsense-specific configuration and support, refer to the [OPNsense documentation](https://docs.opnsense.org/).
