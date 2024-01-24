resource "azapi_resource" "rg_sub1" {
  type      = "Microsoft.Resources/resourceGroups@2022-09-01"
  name      = "rg-demo-azapi-sub1"
  location  = "swedencentral"
  parent_id = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3"

  body = jsonencode({
    properties = {}
  })
}

resource "azapi_resource" "rg_sub2" {
  type      = "Microsoft.Resources/resourceGroups@2022-09-01"
  name      = "rg-demo-azapi-sub2"
  location  = "swedencentral"
  parent_id = "/subscriptions/7bead9cf-e290-4c50-8651-fcc22c9c70a5"

  body = jsonencode({
    properties = {}
  })
}
