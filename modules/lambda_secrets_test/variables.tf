variable "function_name" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "lambda_timeout" {
  type    = number
  default = 10
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.9"
}
