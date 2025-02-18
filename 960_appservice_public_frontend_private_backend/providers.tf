terraform {

  required_version = ">= 1.7.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.19.0"
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
