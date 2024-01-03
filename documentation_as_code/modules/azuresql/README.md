<!-- BEGIN_TF_DOCS -->
# Azure SQL Module
This is module for creating Azure SQL Server and database with added features such as Private Endpoint and storing password in Key Vault.

# Terraform documentation
<!-- markdownlint-disable MD033 -->

## Requirements

No requirements.

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id)

Description: The ID of the Key Vault object in Azure into which generated SQL server password will be stored.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: The location of the SQL Server object in Azure.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the resource group in Azure into which the SQL Server object will be deployed.

Type: `string`

### <a name="input_sql_database_name"></a> [sql\_database\_name](#input\_sql\_database\_name)

Description: The name of SQL database.

Type: `string`

### <a name="input_sql_server_prefix"></a> [sql\_server\_prefix](#input\_sql\_server\_prefix)

Description: The prefix of the SQL Server object in Azure

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint)

Description: Whether to enable private endpoint for the SQL Server.

Type: `bool`

Default: `false`

### <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id)

Description: ID of the private DNS zone to which the private endpoint will be attached.

Type: `string`

Default: `""`

### <a name="input_sql_database_sku"></a> [sql\_database\_sku](#input\_sql\_database\_sku)

Description: SKU string of SQL database, defaults to S0.

Type: `string`

Default: `"S0"`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: ID of the subnet to which the private endpoint will be attached.

Type: `string`

Default: `""`

## Resources

The following resources are used by this module:

- [azurerm_key_vault_secret.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_mssql_database.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) (resource)
- [azurerm_mssql_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) (resource)
- [azurerm_private_endpoint.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [random_password.sql](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_string.sql](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)

## Outputs

The following outputs are exported:

### <a name="output_sql_server_name"></a> [sql\_server\_name](#output\_sql\_server\_name)

Description: The name of the SQL server.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->