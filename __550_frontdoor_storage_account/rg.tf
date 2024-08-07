resource "azurerm_resource_group" "rg" {
  name     = "rg-aks-frontdoor-${var.prefix}"
  location = var.location
}

resource "random_pet" "rg" {}

resource "azurerm_resource_group" "my_resource_group" {
  name     = "${var.resource_group_name}-${random_pet.rg.id}"
  location = var.location
}

resource "random_id" "storage_account_name" {
  byte_length = 8
}

resource "random_id" "front_door_endpoint_name" {
  byte_length = 8
}