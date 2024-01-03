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

```


## Passing secrets via Key Vault