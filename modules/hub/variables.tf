variable "prefix" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "swedencentral"
}

variable "hub_vnet_cidr" {
  type    = string
  default = "172.16.0.0/12"
}
