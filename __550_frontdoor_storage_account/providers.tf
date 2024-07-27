terraform {

  required_version = ">= 1.7.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.112.0"
    }
    
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
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
