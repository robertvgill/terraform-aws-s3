output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = element(concat(aws_s3_bucket.terraform_state.*.id, list("")), 0)
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = element(concat(aws_s3_bucket.terraform_state.*.arn, list("")), 0)
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = element(concat(aws_s3_bucket.terraform_state.*.region, list("")), 0)
}

output "dynamodb_table_name" {
  value       = element(concat(aws_dynamodb_table.terraform_locks.*.name, list("")), 0)
  description = "The name of the DynamoDB table."
}
