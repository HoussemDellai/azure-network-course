variable "prefix" {
  description = "Prefix to be used for all resources in this example"
  type        = string
  default     = "963-001"
}

variable "custom_domain_name" {
  description = "Custom domain name to be used for the App Service"
  type        = string
  default     = "internal-apps-001.com"
}