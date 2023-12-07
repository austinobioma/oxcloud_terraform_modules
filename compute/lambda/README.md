## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.63 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_event_source_mapping.event_source_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.payload_mock](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Additional description | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Map of environment variables | `map(map(string))` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint | `string` | `"app.handler"` | no |
| <a name="input_lambda_role_arn"></a> [lambda\_role\_arn](#input\_lambda\_role\_arn) | See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#role | `string` | n/a | yes |
| <a name="input_log_group_retention"></a> [log\_group\_retention](#input\_log\_group\_retention) | See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#retention_in_days | `number` | `30` | no |
| <a name="input_memory_limit"></a> [memory\_limit](#input\_memory\_limit) | See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#memory_size | `number` | `128` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#reserved_concurrent_executions | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Function runtime. See valid values https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime | `string` | n/a | yes |
| <a name="input_sqs_batch_size"></a> [sqs\_batch\_size](#input\_sqs\_batch\_size) | SQS trigger batch size See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping#batch_size | `number` | `10` | no |
| <a name="input_sqs_triggers"></a> [sqs\_triggers](#input\_sqs\_triggers) | List of sqs queues (ARNs) to can trigger this function | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Maps of common tags to be assigned | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#timeout | `number` | `3` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#vpc_config | `map(list(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN identifier of lambda function |
