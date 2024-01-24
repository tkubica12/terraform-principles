resource "azurerm_virtual_network" "main" {
  name                = "vnet-demo-azurerm"
  location            = azurerm_resource_group.rg_sub1.location
  resource_group_name = azurerm_resource_group.rg_sub1.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg_sub1.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "name" {
  name                = "nic-demo-azurerm"
  location            = azurerm_resource_group.rg_sub1.location
  resource_group_name = azurerm_resource_group.rg_sub1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}
