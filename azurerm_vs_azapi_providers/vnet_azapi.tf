# VNET with subnets in single definition is OK
resource "azapi_resource" "vnet_full" {
  type      = "Microsoft.Network/virtualNetworks@2023-04-01"
  name      = "vnet1-demo-azapi"
  location  = azapi_resource.rg_sub1.location
  parent_id = azapi_resource.rg_sub1.id
  body = jsonencode({
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.0.0.0/16"
        ]
      }
      subnets = [
        {
          name = "default"
          properties = {
            addressPrefix = "10.0.0.0/24"
          }
        }
      ]
    }
  })
}

resource "azapi_resource" "subnet_full_nic" {
  type      = "Microsoft.Network/networkInterfaces@2023-04-01"
  name      = "vnet1-demo-azapi-nic"
  location  = azapi_resource.rg_sub1.location
  parent_id = azapi_resource.rg_sub1.id
  body = jsonencode({
    properties = {
      ipConfigurations = [
        {
          name = "ipconfig"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            subnet = {
              id = "${azapi_resource.vnet_full.id}/subnets/default"
            }
          }
        }
      ]
    }
  })
}

# VNET with subnets in separate definitions might be problematic
resource "azapi_resource" "vnet_separate" {
  type      = "Microsoft.Network/virtualNetworks@2023-04-01"
  name      = "vnet2-demo-azapi"
  location  = azapi_resource.rg_sub1.location
  parent_id = azapi_resource.rg_sub1.id

  # Any change on VNET that causes update (POST) will cause error as subnets are not defined and Azure will attempt to remove it
  tags = {
    tagName1 = "tagValue1"
  }
  body = jsonencode({
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.0.0.0/16"
        ]
      }

    }
  })
  # Ignoring changes to subnets will help if any change happens to it, VNET will not be modified
  ignore_body_changes = [ "properties.subnets" ]
}

resource "azapi_resource" "vnet_separate_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
  name      = "default"
  parent_id = azapi_resource.vnet_separate.id
  body = jsonencode({
    properties = {
      addressPrefix = "10.0.0.0/24"
    }
  })
}

resource "azapi_resource" "subnet_separate_nic" {
  type      = "Microsoft.Network/networkInterfaces@2023-04-01"
  name      = "vnet2-demo-azapi-nic"
  location  = azapi_resource.rg_sub1.location
  parent_id = azapi_resource.rg_sub1.id
  body = jsonencode({
    properties = {
      ipConfigurations = [
        {
          name = "ipconfig"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            subnet = {
              id = azapi_resource.vnet_separate_subnet.id
            }
          }
        }
      ]
    }
  })
}
