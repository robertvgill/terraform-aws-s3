// AWS Credentials
variable "profile" {
  default = "personal"
}

variable "credentials" {
  default = "%AWS_SHARED_CREDENTIALS_FILE%"
//  default = "~/.aws/credentials"
}

// AWS Region
variable "region" {
  default = "ap-southeast-1"
}
