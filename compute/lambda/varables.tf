variable "function_name" {
  description = "Name of lambda function"
  type        = string
}

variable "description" {
  description = "Additional description"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Function runtime. See valid values https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  type        = string
}

variable "handler" {
  description = "Function entrypoint"
  type        = string
  default     = "app.handler"
}

variable "lambda_role_arn" {
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#role"
  type        = string
}

variable "memory_limit" {
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#memory_size"
  type        = number
  default     = 128
}

variable "reserved_concurrent_executions" {
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#reserved_concurrent_executions"
  type        = number
  default     = -1
}

variable "timeout" {
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#timeout"
  type        = number
  default     = 3
}

variable "sqs_triggers" {
  description = "List of sqs queues (ARNs) to can trigger this function"
  type        = set(string)
  default     = []
}

variable "sqs_batch_size" {
  description = "SQS trigger batch size See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping#batch_size"
  type        = number
  default     = 10
}

variable "environment" {
  description = "Map of environment variables"
  type        = map(map(string))
  default     = {}
}

variable "log_group_retention" {
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#retention_in_days"
  type        = number
  default     = 30
}

variable "vpc_config" {
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#vpc_config"
  type        = map(list(string))
  default     = {}
}

variable "tags" {
  description = "Maps of common tags to be assigned"
  type        = map(string)
  default     = {}
}
