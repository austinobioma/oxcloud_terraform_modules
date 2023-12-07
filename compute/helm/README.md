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

## Module Variables

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| helm | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| helm | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app | an application to deploy | `map(any)` | n/a | yes |
| namespace | namespace where to deploy an application | `string` | n/a | yes |
| repository | Helm repository | `string` | n/a | yes |
| repository\_config | repository configuration | `map(any)` | n/a | yes |
| set | Value block with custom STRING values to be merged with the values yaml. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| set\_sensitive | Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff. | <pre>list(object({<br>    path  = string<br>    value = string<br>  }))</pre> | `null` | no |
| values | Extra values | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| deployment | The state of the helm deployment | 