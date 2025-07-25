variable "prefix" {
  description = "Prefix to be used for all resources in this example"
  type        = string
  default     = "520"
}

variable "custom_domain_name" {
  description = "Custom domain name to be used for Application Gateway"
  type        = string
  default     = "azureappgwtls.com"
}