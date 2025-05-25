# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "bucket-terrraform-v3-es"
  
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-locksV2"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
