# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_file = "${path.module}/main.py"
#   output_path = "${path.module}/lambda_function.zip"
# }

# # resource "aws_lambda_function" "sensor_processor" {
# #   filename         = data.archive_file.lambda_zip.output_path
# #   function_name    = "iot_sensor_processor"
# #   role             = data.aws_iam_role.main_role.arn
# #   handler          = "main.lambda_handler"
# #   runtime          = "python3.9"
# #   timeout          = var.lambda_timeout
# # #   source_code_hash = data.archive_file.lambda_zip.output_base64sha256
# #   source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

# #   environment {
# #     variables = {
# #       LOGGING_LEVEL       = "INFO"
# #       DYNAMODB_TABLE_NAME = "ValidSensorDB"
# #       SQS_QUEUE_URL       = "https://sqs.us-east-1.amazonaws.com/931252131472/sensor-data-queue"
# #       SNS_TOPIC_ARN       = var.create_sns_topic ? aws_sns_topic.alerts[0].arn : var.sns_topic_arn
# #     }
# #   }
# # }

# resource "aws_cloudwatch_log_group" "lambda_logs" {
#   name              = "/aws/lambda/${aws_lambda_function.sensor_processor.function_name}"
#   retention_in_days = 7
# }

# resource "aws_sns_topic" "alerts" {
#   count = var.create_sns_topic ? 1 : 0
#   name  = "temperature-alerts"
# }

# resource "aws_lambda_permission" "sns_invoke" {
#   count          = var.create_sns_topic ? 1 : 0
#   statement_id   = "AllowExecutionFromSNS"
#   action         = "lambda:InvokeFunction"
#   function_name  = aws_lambda_function.sensor_processor.function_name
#   principal      = "sns.amazonaws.com"
#   source_arn     = var.sns_topic_arn != "" ? var.sns_topic_arn : aws_sns_topic.alerts[0].arn
# }
