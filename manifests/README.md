# Separate manifests as multi-tool single source of truth
Storing Terraform inputs in Terraform specific format such as tfvars makes it less readable for broad community of users and hard to reuse with other tools. Moreover tfvars typically serve single root, but often you need to have single source of decalarative manifest that is used to deploy complete solution. This might consist of multiple roots as well as other tools such as Ansible, scripts or ArgoCD with Helm for Kubernetes resources. Also for policy as code you might want to have more standard format to work with.

In this example we will create YAML files as manifests for declaring solution parameters and load it with Terraform. With this approach files might have separate shared directory (with different access for people as code itself, different policies for Pull Requests etc.) or even separate repository if needed. YAML format is more readable for both humans and machines, is standardized, vendor and tool independent.

In database folder we have one file per database server and its parameters are listed inside. With our code we than just read all files in directory and create resources accordingly.

```hcl
module "sql" {
  source                  = "github.com/tkubica12/terraform-principles//abstractions_and_interfaces/modules/azuresql?ref=azuresql-v1.0.0"
  for_each                = fileset("${path.module}/databases", "*.yaml")
  sql_server_prefix       = element(split(".", each.key), 0)
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  key_vault_id            = azurerm_key_vault.main.id
  sql_database_name       = yamldecode(file("${path.module}/databases/${each.key}")).db_name
  sql_database_sku        = yamldecode(file("${path.module}/databases/${each.key}")).sku
  enable_private_endpoint = yamldecode(file("${path.module}/databases/${each.key}")).enable_private_endpoint
  subnet_id               = azurerm_subnet.main.id
  private_dns_zone_id     = azurerm_private_dns_zone.sql.id

  depends_on = [azurerm_role_assignment.key_vault]
}
```