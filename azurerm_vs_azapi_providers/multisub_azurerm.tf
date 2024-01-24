resource "azurerm_resource_group" "rg_sub1" {
  name     = "rg-demo-azurerm-sub1"
  location = "swedencentral"
}

resource "azurerm_resource_group" "rg_sub2" {
  provider = azurerm.sub2
  name     = "rg-demo-azurerm-sub2"
  location = "swedencentral"
}