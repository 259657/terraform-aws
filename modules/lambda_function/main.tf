provider "archive" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/main.py"  
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "sensor_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = var.environment_variables
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.sensor_processor.function_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_lambda_function_event_invoke_config" "sns_destination" {
  function_name = aws_lambda_function.sensor_processor.function_name

  destination_config {
    on_success {
      destination = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sensor_processor.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}
