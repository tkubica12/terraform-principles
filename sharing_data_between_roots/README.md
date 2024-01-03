# Sharing data between roots
It might be tempting to put everything into single root Terraform configuration so you can easily deploy from single place and see all dependencies and values. While this is good as part of single project managed by single team, it might cause issues when it becomes to big:
- It takes time to refresh state and deploy, having thousands of resources make it slow to deploy changes
- Large blast radius - corrupted states will have more severe impact
- Creating unwanted dependencies - if multiple projects and environments are in single root, code problems in one prevent whole thing from deploying making teams wait for each other
- Dictating tools to use between different teams is not desirable - eg. infra team wants to use Terraform while application teams wants to deploy with Pulumi a that should be OK. Split base infrastructure part (eg. networking) from application related part (database, compute).

It is therefore common to have multiple roots with split responsibilities such as one deploying base infra and other application related components or one deploying hub environment and separate ones for each landing zone (spoke network). Make sure split is done in a way that as little information need to be shared between those (two much need for sharing typically means you have split it wrong). Nevertheless - something usualy needs to be passed from one to another such as resource IDs (eg. subnet ID), names or passwords.

Options:
- Using remote state feature of Terraform does bring security challenges - not recommended
- You can use Terraform Enterprise outputs feature [tfe_outputs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/outputs), but it is specific to TFE and might not be best for secrets
- Export outputs to files and check them in to Git - universal approach, vendor neutral, I would recommend it for non-secret stuff
- Export secrets to proper vault such as Azure Key Vault and pass reference to it
- Read data yourself with data sources - works very well, but second Terraform root needs to have permissions to access those resources in cloud (unlike passing just strings)
- You can pass information to other systems via some Terraform resources such as cloud Tags, Kubernetes ConfigMaps etc. -> this can be target specific, I would rather recommend Git-based approach

## Exporting outputs and checking into Git
Look at stage1 code and see how local YAML file is constructed.

```hcl
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
```

This is result.

```yaml
"hub_vnet_id": "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/rg-tfmultiroot-stage1/providers/Microsoft.Network/virtualNetworks/vnet-multiroot-hub"
"hub_vnet_name": "vnet-multiroot-hub"
"hub_vnet_rg_name": "rg-tfmultiroot-stage1"
```

You should be running Terraform from CI/CD pipeline, so you can than take this file and check it into Git after each deployment.

Than you may just reference this in information in other root module (stage2 in my case).

```hcl
variable "stage1_runtime_yaml" {
  type = string
  default = "sharing_data_between_roots/stage1/stage1_runtime.yaml"
}

data "github_repository" "tkubica12" {
  full_name = "tkubica12/terraform-principles"
}

data "github_repository_file" "stage1_runtime" {
  repository          = data.github_repository.tkubica12.name
  branch              = "main"
  file                = var.stage1_runtime_yaml
}

locals {
  stage1_runtime = yamldecode(data.github_repository_file.stage1_runtime.content)
}

resource "azurerm_resource_group" "main" {
  name     = "rg-tfmultiroot-stage2"
  location = "swedencentral"
  tags = {
    "hub_vnet_id" = local.stage1_runtime.hub_vnet_id   # This is info from stage1 root
  }
}
```

## Passing secrets via Key Vault
You should never store secrets in Git (unless you encrypt them - sealed secrets), but rather in proper place such as Azure Key Vault. Let's now save secret to Key Vault in one root and pass reference to it to another one.

```hcl
resource "random_password" "sql" {
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  length      = 16
}

resource "random_string" "key_vault" {
  numeric = false
  lower   = true
  upper   = false
  special = false
  length  = 12
}

resource "azurerm_key_vault" "main" {
  name                        = random_string.key_vault.result
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
}

resource "azurerm_role_assignment" "key_vault" {
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.main.id
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "main" {
  name         = "mysecret"
  value        = random_password.sql.result
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.key_vault]
}

locals {
    hub_vnet_id = {"hub_vnet_id" = azurerm_virtual_network.main.id}
    hub_vnet_name = {"hub_vnet_name" = azurerm_virtual_network.main.name}
    hub_vnet_rg_name = {"hub_vnet_rg_name" = azurerm_resource_group.main.name}
    kv_id = {"kv_id" = azurerm_key_vault.main.id}
    kv_secret_name = {"kv_secret_name" = azurerm_key_vault_secret.main.name}
    merged_output = merge(local.hub_vnet_id, local.hub_vnet_name, local.hub_vnet_rg_name, local.kv_id, local.kv_secret_name)
    yaml_merged_output = yamlencode(local.merged_output)
}

resource "local_file" "stage1_runtime" {
  content  = local.yaml_merged_output
  filename = "stage1_runtime.yaml"
}
```

Now we can read and use this in different Terraform root.

```hcl
variable "stage1_runtime_yaml" {
  type = string
  default = "sharing_data_between_roots/stage1/stage1_runtime.yaml"
}

data "github_repository" "tkubica12" {
  full_name = "tkubica12/terraform-principles"
}

data "github_repository_file" "stage1_runtime" {
  repository          = data.github_repository.tkubica12.name
  branch              = "main"
  file                = var.stage1_runtime_yaml
}

locals {
  stage1_runtime = yamldecode(data.github_repository_file.stage1_runtime.content)
}

data "azurerm_key_vault_secret" "stage1_secret" {
  name         = local.stage1_runtime.kv_secret_name
  key_vault_id = local.stage1_runtime.kv_id
}

resource "azurerm_resource_group" "main" {
  name     = "rg-tfmultiroot-stage2"
  location = "swedencentral"
  tags = {
    "hub_vnet_id" = local.stage1_runtime.hub_vnet_id
    "secret" = data.azurerm_key_vault_secret.stage1_secret.value
  }
}
```