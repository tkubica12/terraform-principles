resource "azurerm_resource_group" "main" {
  name     = "rg-tfmultiroot-stage1"
  location = "swedencentral"
}

data "azurerm_client_config" "current" {}