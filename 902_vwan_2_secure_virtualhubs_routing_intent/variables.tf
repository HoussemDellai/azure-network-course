variable "prefix" {
  description = "Prefix to be used for resources in this example"
  type        = string
  default     = "902"
}

variable "region1" {
  description = "Location for the virtual Hub resources"
  type        = string
  default     = "swedencentral"
}

variable "region2" {
  description = "Location for the virtual Hub resources"
  type        = string
  default     = "francecentral"
}