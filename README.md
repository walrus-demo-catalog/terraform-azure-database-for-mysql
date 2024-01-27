<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.88.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.88.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_mysql_flexible_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.fs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_private_dns_zone.pdz](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.sn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | Specify the deployment architecture, select from standalone or replication. | `string` | `"standalone"` | no |
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br><br>Examples:<pre>context:<br>  project:<br>    name: string<br>    id: string<br>  environment:<br>    name: string<br>    id: string<br>  resource:<br>    name: string<br>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_database"></a> [database](#input\_database) | Specify the database name. The database name must be 2-64 characters long and start with any lower letter, combined with number, or symbols: - \_. <br>The database name cannot be MySQL forbidden keyword. | `string` | `"mydb"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Specify the deployment engine version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. | `string` | `"8.0.21"` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Specify the infrastructure information for deploying.<br><br>Examples:<pre>infrastructure:<br>  domain_suffix: string,optional  # a private DNS namespace of the PrivateZone where to register the applied MySQL service. It must end with 'mysql.database.azure.com'</pre> | <pre>object({<br>    domain_suffix = optional(string)<br>  })</pre> | <pre>{<br>  "domain_suffix": null<br>}</pre> | no |
| <a name="input_password"></a> [password](#input\_password) | Specify the account password. The password must be 8-128 characters long and start with any letter, number, or symbols: ! # $ % ^ & * ( ) \_ + - =.<br>If not specified, it will generate a random password. | `string` | `null` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Specify the computing resources.<br>The computing resource design of Azure Cloud is very complex, it also needs to consider on the storage resource, please view the specification document for more information.<br>For example: B\_Standard\_B1s, GP\_Standard\_D2ads\_v5 or BC\_Standard\_E2ds\_v4<br>See https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-service-tiers-storage#service-tiers-size-and-server-types.<br>Examples:<pre>resources:<br>  class: string, optional            # sku<br>  readonly_class: string, optional   #</pre> | <pre>object({<br>    class          = optional(string, "B_Standard_B1s")<br>    readonly_class = optional(string)<br>  })</pre> | <pre>{<br>  "class": "B_Standard_B1s"<br>}</pre> | no |
| <a name="input_storage"></a> [storage](#input\_storage) | Choosing the storage resource is also related to the computing resource, please view the specification document for more information.<br><br>Examples:<pre>storage:<br>  size: number, optional         # in megabyte</pre> | <pre>object({<br>    size = optional(number, 20 * 1024)<br>  })</pre> | <pre>{<br>  "size": 20480<br>}</pre> | no |
| <a name="input_username"></a> [username](#input\_username) | Specify the account username. The username must be 1-63 characters long and start with lower letter, combined with number.<br>The username cannot be MySQL forbidden keyword and azure\_superuser, admin, administrator, root, guest or public. | `string` | `"rdsuser"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection"></a> [connection](#output\_connection) | The connection, also the fully qualified domain name of the MySQL Flexible Server. |
| <a name="output_context"></a> [context](#output\_context) | The input context, a map, which is used for orchestration. |
| <a name="output_database"></a> [database](#output\_database) | The name of MySQL database to access. |
| <a name="output_password"></a> [password](#output\_password) | The password of the account to access the database. |
| <a name="output_public_network_access_enabled"></a> [public\_network\_access\_enabled](#output\_public\_network\_access\_enabled) | The public network access enabled or not. |
| <a name="output_username"></a> [username](#output\_username) | The username of the account to access the database. |
<!-- END_TF_DOCS -->