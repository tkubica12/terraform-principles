resource "azurerm_resource_group" "main" {
  name     = "rg-tfabstractions"
  location = "swedencentral"
}

module "sql" {
  source                  = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/azuresql?ref=azuresql-v1.0.0"
  sql_server_prefix       = "tfabstractions"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  key_vault_id            = azurerm_key_vault.main.id
  sql_database_name       = "mydb"
  enable_private_endpoint = true
  subnet_id               = azurerm_subnet.main.id
  private_dns_zone_id     = azurerm_private_dns_zone.sql.id

  depends_on = [azurerm_role_assignment.key_vault]
}

data "azurerm_client_config" "current" {}