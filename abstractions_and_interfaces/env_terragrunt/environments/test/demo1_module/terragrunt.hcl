terraform {
  source = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/demo1_module?ref=demo-v2.0.0"
}

dependency "parent" {
  config_path = "../"
  mock_outputs = {
    rg_name     = "rg_name_not_ready"
    location    = "location_not_ready"
    environment = "environment_not_ready"
  }
}

inputs = {
  prefix   = dependency.parent.outputs.environment
  rg_name  = dependency.parent.outputs.rg_name
  location = dependency.parent.outputs.location
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}
