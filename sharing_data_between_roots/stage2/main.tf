resource "azurerm_resource_group" "main" {
  name     = "rg-tfmultiroot-stage2"
  location = "swedencentral"
  tags = {
    "hub_vnet_id" = local.stage1_runtime.hub_vnet_id
    "secret" = data.azurerm_key_vault_secret.stage1_secret.value
  }
}