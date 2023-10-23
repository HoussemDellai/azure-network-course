variable "resource_group_name" {}
variable "location" {}
variable "tags" {}
variable "subnet_id" {}
variable "vm_name" {}
variable "vm_size" {
  type    = string
  default = "Standard_B1ms" # Standard_B2ls_v2 # Standard_B2s_v2
}
variable "admin_username" {
  type    = string
  default = "azureadmin"
}
variable "admin_password" {
  type    = string
  default = "@Aa123456789"
}
variable "enable_public_ip" {
  type    = bool
  default = false
}
variable "enable_ip_forwarding" {
  type    = bool
  default = false
}
variable "install_webapp" {
  type    = bool
  default = false
}
