provider "aws" {
  region = var.aws_region
}

data "aws_iam_role" "main_role" {
  name = "LabRole"
}

module "sensor_lambda" {
  source          = "./modules/lambda_function"
  function_name   = "iot_sensor_processor"
  lambda_role_arn = data.aws_iam_role.main_role.arn
  lambda_timeout  = var.lambda_timeout
  environment_variables = {
    LOGGING_LEVEL       = "INFO"
    DYNAMODB_TABLE_NAME = "ValidSensorDB"
    SQS_QUEUE_URL       = "https://sqs.us-east-1.amazonaws.com/931252131472/sensor-data-queue"
    SNS_TOPIC_ARN       = var.sns_topic_arn
  }
  sns_topic_arn = var.sns_topic_arn
}

module "secrets_lambda_test" {
  source            = "./modules/lambda_secrets_test"
  function_name     = "secrets_test_lambda"
  lambda_role_arn   = data.aws_iam_role.main_role.arn
  lambda_timeout    = 10
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/spp-db/password"
  description = "Hasło do bazy spp-db"
  type        = "SecureString"
  value       = var.db_password
  overwrite   = true
}


# aws lambda invoke --function-name iot_sensor_processor --cli-binary-format raw-in-base64-out --payload file://event.json output.json

# # provider "aws" {
# #   region = "us-east-1"
# #   # shared_credentials_files = [ "~/.aws/credentials" ]
# #   # profile = "default"
#
# # }
# provider "aws" {
#   region = var.aws_region
# }


# provider "archive" {}

# data "aws_iam_role" "main_role" {
#   name = "LabRole"
# }




# # Archiwum ZIP z funkcją Lambda
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_file = "${path.module}/main.py"
#   output_path = "${path.module}/lambda_function.zip"
# }

# # Funkcja Lambda
# resource "aws_lambda_function" "sensor_processor" {
#   filename         = data.archive_file.lambda_zip.output_path
#   function_name    = "iot_sensor_processor"
#   role             = data.aws_iam_role.main_role.arn
#   handler          = "main.lambda_handler"
#   runtime          = "python3.9"
#   timeout          = var.lambda_timeout
#   source_code_hash = data.archive_file.lambda_zip.output_base64sha256

#   environment {
#     variables = {
#       LOGGING_LEVEL       = "INFO"
#       DYNAMODB_TABLE_NAME = "ValidSensorDB"
#       SQS_QUEUE_URL       = "https://sqs.us-east-1.amazonaws.com/931252131472/sensor-data-queue"
#       SNS_TOPIC_ARN       = "arn:aws:sns:us-east-1:931252131472:SNS"
#     }
#   }
# }

# # CloudWatch log group
# resource "aws_cloudwatch_log_group" "lambda_logs" {
#   name              = "/aws/lambda/${aws_lambda_function.sensor_processor.function_name}"
#   retention_in_days = 7
# }

# # Konfiguracja zdarzeń dla Lambdy (wysyłka sukcesu do SNS)
# resource "aws_lambda_function_event_invoke_config" "sns_destination" {
#   function_name = aws_lambda_function.sensor_processor.function_name

#   destination_config {
#     on_success {
#       destination = var.sns_topic_arn
#     }
#   }
# }

# # Pozwolenie dla SNS na wywołanie Lambdy
# resource "aws_lambda_permission" "sns_invoke" {
#   statement_id  = "AllowExecutionFromSNS"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.sensor_processor.function_name
#   principal     = "sns.amazonaws.com"
#   source_arn    = var.sns_topic_arn
# }