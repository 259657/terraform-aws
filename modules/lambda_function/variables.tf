variable "function_name" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "lambda_handler" {
  type    = string
  default = "main.lambda_handler"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.9"
}

variable "lambda_timeout" {
  type    = number
  default = 10
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "sns_topic_arn" {
  type    = string
  default = ""
}
