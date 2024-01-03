<!-- BEGIN_TF_DOCS -->
# Documentation as Code
Documenting inputs, outputs, used components and modules is important hygiene factor for any project. Generating documentation automatically from code is a great way to ensure that documentation is always up to date and consistent with the code. Make sure you provide description to your inputs and outputs in rich format, use multiline strings and provide examples.

# Terraform documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~>3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~>3)

## Modules

The following Modules are called:

### <a name="module_sql"></a> [sql](#module\_sql)

Source: ./modules/azuresql

Version:

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_databases"></a> [databases](#input\_databases)

Description: Map of databases to create.

Each database is represented by a map with the following keys:
- db\_name: The name of the database.
- sku: SKU string of the database, defaults to S0.
- enable\_private\_endpoint: Whether to enable private endpoint for the database.

Here is full example:

```
    mydemo1 = {
      db_name                 = "mydemo"
      sku                     = "S0"
      enable_private_endpoint = true
    }
    mydemo2 = {
      db_name                 = "mydemo"
      sku                     = "S0"
      enable_private_endpoint = true
    }
    mydemo3 = {
      db_name                 = "mydemo"
      sku                     = "S0"
      enable_private_endpoint = true
    }
```

Type:

```hcl
map(object({
    db_name                 = string
    sku                     = string
    enable_private_endpoint = bool
  }))
```

Default:

```json
{
  "defaultdb": {
    "db_name": "defaultdb",
    "enable_private_endpoint": true,
    "sku": "S0"
  }
}
```

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource group will be created.

Type: `string`

Default: `"West Europe"`

## Resources

The following resources are used by this module:

- [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_private_dns_zone.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_private_dns_zone_virtual_network_link.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) (resource)
- [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_role_assignment.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_subnet.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_string.key_vault](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Outputs

The following outputs are exported:

### <a name="output_sql_server_names"></a> [sql\_server\_names](#output\_sql\_server\_names)

Description: List of SQL server names. Example:

sql\_server\_names = [
    "sql-1",
    "sql-2",
]

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->