resource "azurerm_resource_group" "main" {
  name     = "rg-nesteddemo-${var.environment}"
  location = "swedencentral"
}

module "m1" {
  source   = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/demo1_module?ref=demo-v1.0.0"
  prefix   = var.environment
  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

module "m2" {
  source   = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/demo2_module?ref=demo-v1.0.0"
  prefix   = var.environment
  rg_name  = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}
