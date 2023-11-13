output "commands" {
  value = <<-EOT
        # 1. connect to the VMs via Bastion and SSH and use password : ${var.vm_admin_password}

        az network bastion ssh -n ${module.bastion.bastion_name} -g ${azurerm_resource_group.rg-hub.name} --target-resource-id ${module.vm-spoke1.vm_id} --auth-type password --username ${var.vm_admin_username}
        
        az network bastion ssh -n ${module.bastion.bastion_name} -g ${azurerm_resource_group.rg-hub.name} --target-resource-id ${module.vm-spoke2.vm_id} --auth-type password --username ${var.vm_admin_username}
      
        # 2. Install the webapp on the VMs

        # 3. Test the webapp on the VMs

        ping ${module.vm-spoke1.vm_private_ip}

        ping ${module.vm-spoke2.vm_private_ip}

        traceroute ${module.vm-spoke1.vm_private_ip}

        traceroute ${module.vm-spoke2.vm_private_ip}

        nslookup ${azurerm_private_dns_a_record.dns_a_record_vm_spoke1.fqdn}

        nslookup ${azurerm_private_dns_a_record.dns_a_record_vm_spoke2.fqdn}
      EOT
}

# resource "terraform_data" "commands" {
#   #   triggers_replace = [var.image_tag_aca_app_web]

#   #   lifecycle {
#   #     replace_triggered_by = [module.bastion]
#   #   }

#   provisioner "local-exec" {

#     # interpreter = ["PowerShell", "-Command"]
#     command = <<-EOT
#         az network bastion ssh -n ${module.bastion.bastion_name} -g ${azurerm_resource_group.rg-hub.name} --target-resource-id ${module.vm-hub-nva.vm_id} --auth-type password --username azureuser
#         az network bastion ssh -n ${module.bastion.bastion_name} -g ${azurerm_resource_group.rg-hub.name} --target-resource-id ${module.vm-spoke1.vm_id} --auth-type password --username azureuser
#         az network bastion ssh -n ${module.bastion.bastion_name} -g ${azurerm_resource_group.rg-hub.name} --target-resource-id ${module.vm-spoke2.vm_id} --auth-type password --username azureuser
#       EOT
#     when    = create
#   }
# }