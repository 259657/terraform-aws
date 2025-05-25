variable "aws_region" {
  description = "Region AWS"
  default     = "us-east-1"
}

variable "lambda_timeout" {
  description = "Timeout Lambdy"
  type        = number
  default     = 10
}

variable "create_sns_topic" {
  description = "Czy utworzyć SNS Topic?"
  type        = bool
  default     = false
}

# variable "sns_topic_arn" {
#   type        = string
#   default     = "arn:aws:sns:us-east-1:931252131472:SNS" 
#   description = "ARN istniejącego tematu SNS"
# }
variable "sns_topic_arn" {
  type    = string
  default = "arn:aws:sns:us-east-1:931252131472:SNS" 
}

variable "error_sns_topic_arn" {
  type    = string
  default = ""
}