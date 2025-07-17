variable "prefix" {
  description = "Prefix to be used for resources in this example"
  type        = string
  default     = "901"
}

variable "region1" {
  description = "The Azure region for the first virtual hub"
  type        = string
  default     = "swedencentral"
}

variable "region2" {
  description = "The Azure region for the second virtual hub"
  type        = string
  default     = "francecentral"
}