
data "archive_file" "payload_mock" {
  type        = "zip"
  output_path = "${path.module}/function_payload.zip"
  source {
    content  = "mock"
    filename = "app.js"
  }
}
resource "aws_lambda_function" "lambda" {
  function_name                  = var.function_name
  description                    = var.description
  handler                        = var.handler
  role                           = var.lambda_role_arn
  runtime                        = var.runtime
  filename                       = data.archive_file.payload_mock.output_path
  timeout                        = var.timeout
  memory_size                    = var.memory_limit
  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "environment" {
    for_each = length(var.environment) < 1 ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_config) < 1 ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  tags = merge(
    {
      "Name"       = var.function_name
      "Terragrunt" = "True"
    },
    var.tags,
  )

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  for_each = var.sqs_triggers

  batch_size       = var.sqs_batch_size
  event_source_arn = each.value
  enabled          = true
  function_name    = aws_lambda_function.lambda.arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_group_retention

  tags = merge(
    {
      "Name"       = var.function_name
      "Terragrunt" = "True"
    },
    var.tags,
  )
}
