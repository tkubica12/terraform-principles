module "naming" {
  source = "Azure/naming/azurerm"
  suffix = ["tomastest"]
}

resource "azurerm_resource_group" "main" {
  name     = module.naming.resource_group.name
  location = "swedencentral"
}

resource "azurerm_storage_account" "storage1" {
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "main" {
  name                = module.naming.virtual_network.name
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

module "naming_app2" {
  source = "Azure/naming/azurerm"
  suffix = ["tomastest", "app2"]
}

resource "azurerm_storage_account" "storage2" {
  name                     = module.naming_app2.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "main2" {
  name                = module.naming_app2.virtual_network.name
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}
