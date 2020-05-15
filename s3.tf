# Terraform version
terraform {
  required_version = ">= 0.12"
}

# Create the S3 bucket
resource "aws_s3_bucket" "terraform_state_s3" {
  bucket = var.bucket_name

# Enable versioning
  versioning {
    enabled = true
  }

# Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-lock-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
