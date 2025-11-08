terraform {

  required_version = ">=1.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.52.0"
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
