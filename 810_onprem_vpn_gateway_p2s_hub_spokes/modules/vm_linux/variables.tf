variable "resource_group_name" {}
variable "location" {}
variable "subnet_id" {}
variable "vm_name" {}
variable "enable_public_ip" {
  type    = bool
  default = false
}
variable "install_webapp" {
  type    = bool
  default = false
}
