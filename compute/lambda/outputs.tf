output "arn" {
  description = "ARN identifier of lambda function"
  value       = aws_lambda_function.lambda.arn
}
