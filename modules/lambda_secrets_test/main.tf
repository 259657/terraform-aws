data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/test_secrets.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "secrets_test" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = "test_secrets.lambda_handler"
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

    environment {
        variables = {
            DB_PASSWORD_PARAM = "/spp-db/password"
        }
    }
}