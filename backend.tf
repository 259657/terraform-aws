terraform {
  backend "s3" {
    bucket         = "bucket-terrraform-v3-es"            # Twój bucket
    key            = "terraform.tfstate"                      # Ścieżka pliku stanu
    region         = "us-east-1"                              # Region bucketu
    dynamodb_table = "terraform-locksV2"                        # Tabela blokady
    encrypt        = true                                     # Szyfrowanie
  }
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "bucket-terrraform-v3-es"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

