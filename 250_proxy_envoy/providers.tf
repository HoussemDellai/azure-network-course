terraform {

  required_version = ">= 1.13.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.47.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.7.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {}
