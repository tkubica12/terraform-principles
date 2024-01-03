resource "azurerm_resource_group" "main" {
  name     = "rg-tfabstractions"
  location = "swedencentral"
}

module "sql" {
  source                  = "./modules/azuresql"
  for_each                = fileset("${path.module}/databases", "*.yaml")
  sql_server_prefix       = element(split(".", each.key), 0)
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  key_vault_id            = azurerm_key_vault.main.id
  sql_database_name       = yamldecode(file("${path.module}/databases/${each.key}")).db_name
  sql_database_sku        = yamldecode(file("${path.module}/databases/${each.key}")).sku
  enable_private_endpoint = yamldecode(file("${path.module}/databases/${each.key}")).enable_private_endpoint
  subnet_id               = azurerm_subnet.main.id
  private_dns_zone_id     = azurerm_private_dns_zone.sql.id

  depends_on = [azurerm_role_assignment.key_vault]
}

data "azurerm_client_config" "current" {}