module "m1" {
  source      = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/demo1_module?ref=demo-v2.0.0"
  environment = "test"
}

module "m2" {
  source      = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/demo2_module?ref=demo-v1.0.0"
  environment = "test"
}