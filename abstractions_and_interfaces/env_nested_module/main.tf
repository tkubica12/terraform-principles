resource "azurerm_resource_group" "main" {
  name     = "rg-nesteddemo-${var.environment}"
  location = "swedencentral"
}

module "main" {
  source   = "../modules/demo1_module"
  prefix   = var.environment
  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}
