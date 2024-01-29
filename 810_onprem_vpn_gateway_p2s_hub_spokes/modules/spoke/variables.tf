variable "spoke_name" { type = string }
variable "spoke_rg_location" { type = string }
variable "spoke_vnet_cidr" { type = string }
variable "allow_gateway_transit" { type = bool }
variable "hub_vnet" { type = object({
  name = string,
  rg   = string,
id = string }) }
