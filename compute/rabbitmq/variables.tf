variable "broker_name" {
  description = "Broker name of RabbitMQ"
  type        = string
}

variable "deployment_mode" {
  description = "Deployemnt mode of RabbitMQ. Single node or cluster"
  type        = string
}

variable "engine_version" {
  description = "RabbitMQ engine version to be deployed"
  type        = string
}

variable "type" {
  description = "Instance type to be deployed"
  type        = string
}

variable "security_group" {
  description = "Security group to be attached to RabbitMQ"
  type        = string
}

variable "subnet_id" {
  description = "Subnets ID to be use for RabbitMQ deployment"
  type        = string
}

variable "subnet_id_secondary" {
  description = "Secondary Subnets ID for multicluster to be use for RabbitMQ deployment"
  type        = string
}

variable "rabbitmq_username" {
  description = "Username of RabbitMQ"
  type        = string
}

variable "password_vault_path" {
  description = "path to password secret in vault"
  type        = string
}

variable "arn_role" {
  description = "Role ARN to be used for deployment"
  type        = string
}

variable "aws_shared_credentials_file" {
  description = "Specifies the location of the file that the AWS CLI uses to store access keys."
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "Specifies the name of the CLI profile with the credentials and options to use. This can be the name of a profile stored in a credentials or config file."
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "Specifies the AWS Region to send the request to."
  type        = string
  default     = ""
}

variable "m_time" {
  description = "Maintance Window Start Time"
  type        = string
  default     = "01:00"
}

variable "m_day" {
  description = "Maintance Window Day"
  type        = string
  default     = "SUNDAY"
}

variable "m_timezone" {
  description = "Maintance Window Timezone"
  type        = string
  default     = "UTC"
}
