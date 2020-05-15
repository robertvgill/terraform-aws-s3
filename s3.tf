locals {
  prevent_unencrypted_uploads = var.prevent_unencrypted_uploads && var.enable_server_side_encryption ? true : false

  policy = local.prevent_unencrypted_uploads ? join(
    "",
    data.aws_iam_policy_document.prevent_unencrypted_uploads.*.json
  ) : ""

  terraform_backend_config_file = format(
    "%s/%s",
    var.terraform_backend_config_file_path,
    var.terraform_backend_config_file_name
  )
}

data "aws_iam_policy_document" "prevent_unencrypted_uploads" {
  count = local.prevent_unencrypted_uploads ? 1 : 0

  statement {
    sid = "DenyIncorrectEncryptionHeader"

    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${var.arn_format}:s3:::${var.s3_bucket_name}/*",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "AES256",
      ]
    }
  }

  statement {
    sid = "DenyUnEncryptedObjectUploads"

    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${var.arn_format}:s3:::${var.s3_bucket_name}/*",
    ]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "true",
      ]
    }
  }

  statement {
    sid = "EnforceTlsRequestsOnly"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "${var.arn_format}:s3:::${var.s3_bucket_name}",
      "${var.arn_format}:s3:::${var.s3_bucket_name}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Create the S3 bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket        = substr(var.s3_bucket_name, 0, 63)
  acl           = var.acl
  region        = var.region
  force_destroy = var.force_destroy
  policy        = local.policy

# Enable versioning
  versioning {
    enabled     = true
    mfa_delete  = var.mfa_delete
  }

# Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.s3_bucket_name)
    }
  )
}

# Create a DynamoDB table resource
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
}
