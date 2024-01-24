resource "azurerm_storage_account" "main" {
  name                     = "${var.prefix}demo1version2${random_string.main.result}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "main" {
  length  = 4
  special = false
  lower   = true
  upper   = false
  numeric = false
}
