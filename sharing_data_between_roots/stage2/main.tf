resource "azurerm_resource_group" "main" {
  name     = "rg-tfmultiroot-stage2"
  location = "swedencentral"
  tags = {
    "hub_vnet_id" = stage1_runtime.hub_vnet_id
  }
}