module "main" {
  source                  = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/demo1_module?ref=demo-v1.0.0"
  environment = "prod"
}
