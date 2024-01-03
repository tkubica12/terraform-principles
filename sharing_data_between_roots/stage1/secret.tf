resource "random_password" "sql" {
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  length      = 16
}

resource "random_string" "key_vault" {
  numeric = false
  lower   = true
  upper   = false
  special = false
  length  = 12
}

resource "azurerm_key_vault" "main" {
  name                        = random_string.key_vault.result
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
}

resource "azurerm_role_assignment" "key_vault" {
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.main.id
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "main" {
  name         = "mysecret"
  value        = random_password.sql.result
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.key_vault]
}
