data "azurerm_key_vault_secret" "stage1_secret" {
  name         = local.stage1_runtime.kv_secret_name
  key_vault_id = local.stage1_runtime.kv_id
}
