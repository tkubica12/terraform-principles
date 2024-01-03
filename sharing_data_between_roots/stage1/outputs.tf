locals {
    hub_vnet_id = {"hub_vnet_id" = azurerm_virtual_network.main.id}
    hub_vnet_name = {"hub_vnet_name" = azurerm_virtual_network.main.name}
    hub_vnet_rg_name = {"hub_vnet_rg_name" = azurerm_resource_group.main.name}
    merged_output = merge(local.hub_vnet_id, local.hub_vnet_name, local.hub_vnet_rg_name)
    yaml_merged_output = yamlencode(local.merged_output)
}

resource "local_file" "stage1_runtime" {
  content  = local.yaml_merged_output
  filename = "stage1_runtime.yaml"
}