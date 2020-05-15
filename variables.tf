# Configure the AWS Provider

# AWS Region
variable "region" {
  description = "The name AWS region"
  type = string
}

variable "credentials" {
  description = "The location of the Shared Credentials file"
  default = "%AWS_SHARED_CREDENTIALS_FILE%"
//  default = "~/.aws/credentials"
}

variable "profile" {
  description = "The name of the AWS profile to use for the instance"
  type = string
}

# S3 Bucket Configuration
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type = string
}
