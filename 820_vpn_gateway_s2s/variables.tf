variable "prefix" {
  description = "Prefix to be used for resources in this example"
  type        = string
  default     = "820"
}

variable "onpremise_bgp_asn" {
  type        = number
  default     = 64000
  description = "On-premise BGP ASN"
}

variable "azure_bgp_asn" {
  type        = number
  default     = 65000
  description = "Azure BGP ASN"
}