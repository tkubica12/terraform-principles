module "main" {
  source      = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/env_nested_module?ref=nested-v2.0.0"
  environment = "test"
}
