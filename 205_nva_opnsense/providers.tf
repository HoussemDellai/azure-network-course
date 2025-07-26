terraform {

  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.27.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.4.0"
    }
  }
}

provider "azurerm" {
  use_cli = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {}
