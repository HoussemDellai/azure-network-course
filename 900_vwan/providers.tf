terraform {

  required_version = ">= 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.12.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "dcef7009-6b94-4382-afdc-17eb160d709a"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
