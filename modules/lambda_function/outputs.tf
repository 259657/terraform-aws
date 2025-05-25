output "lambda_function_name" {
  value = aws_lambda_function.sensor_processor.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.sensor_processor.arn
}
