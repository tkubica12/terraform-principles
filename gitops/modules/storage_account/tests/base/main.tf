module "naming" {
  source = "Azure/naming/azurerm"
  suffix = ["test"]
}

resource "azurerm_resource_group" "main" {
  name     = module.naming.resource_group.name_unique
  location = "swedencentral"
}
