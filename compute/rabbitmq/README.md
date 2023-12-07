## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.create-rabbitmq](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [vault_generic_secret.secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arn_role"></a> [arn\_role](#input\_arn\_role) | Role ARN to be used for deployment | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | Specifies the name of the CLI profile with the credentials and options to use. This can be the name of a profile stored in a credentials or config file. | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Specifies the AWS Region to send the request to. | `string` | `""` | no |
| <a name="input_aws_shared_credentials_file"></a> [aws\_shared\_credentials\_file](#input\_aws\_shared\_credentials\_file) | Specifies the location of the file that the AWS CLI uses to store access keys. | `string` | `"~/.aws/credentials"` | no |
| <a name="input_broker_name"></a> [broker\_name](#input\_broker\_name) | Broker name of RabbitMQ | `string` | n/a | yes |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | Deployemnt mode of RabbitMQ. Single node or cluster | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | RabbitMQ engine version to be deployed | `string` | n/a | yes |
| <a name="input_m_day"></a> [m\_day](#input\_m\_day) | Maintance Window Day | `string` | `"SUNDAY"` | no |
| <a name="input_m_time"></a> [m\_time](#input\_m\_time) | Maintance Window Start Time | `string` | `"01:00"` | no |
| <a name="input_m_timezone"></a> [m\_timezone](#input\_m\_timezone) | Maintance Window Timezone | `string` | `"UTC"` | no |
| <a name="input_password_vault_path"></a> [password\_vault\_path](#input\_password\_vault\_path) | path to password secret in vault | `string` | n/a | yes |
| <a name="input_rabbitmq_username"></a> [rabbitmq\_username](#input\_rabbitmq\_username) | Username of RabbitMQ | `string` | n/a | yes |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Security group to be attached to RabbitMQ | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnets ID to be use for RabbitMQ deployment | `string` | n/a | yes |
| <a name="input_subnet_id_secondary"></a> [subnet\_id\_secondary](#input\_subnet\_id\_secondary) | Secondary Subnets ID for multicluster to be use for RabbitMQ deployment | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Instance type to be deployed | `string` | n/a | yes |

## Outputs

No outputs.
