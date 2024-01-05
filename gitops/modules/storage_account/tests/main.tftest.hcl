run "setup_base_environment" {
  module {
    source = "./tests/base"
  }
}

run "test_with_pe" {
  command = apply

  variables {
    name_prefix             = "withpe"
    resource_group_name     = run.setup_base_environment.rg_name
    location                = run.setup_base_environment.location
    subnet_id               = run.setup_base_environment.subnet_id
    private_dns_zone_id     = run.setup_base_environment.private_dns_zone_id
    enable_private_endpoint = true
  }
}

run "test_without_pe" {
  command = apply

  variables {
    name_prefix             = "withoutpe"
    resource_group_name     = run.setup_base_environment.rg_name
    location                = run.setup_base_environment.location
    enable_private_endpoint = false
  }
}
