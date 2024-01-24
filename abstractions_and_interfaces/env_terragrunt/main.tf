resource "azurerm_resource_group" "main" {
  name     = "rg-nesteddemo-${var.environment}"
  location = "swedencentral"
}