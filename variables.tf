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
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type = string
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default = [{
    name = "LockID"
    type = "S"
  }]
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
  default     = "LockID"
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}
