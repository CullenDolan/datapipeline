terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

resource "aws_s3_bucket" "cullen-tf-s3-bucket-123" {
  bucket = "cullen-tf-s3-bucket-123"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "cullen-tf-s3-bucket-123" {
  bucket = aws_s3_bucket.cullen-tf-s3-bucket-123.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "tf-file-upload" {
  name = "tf-file-upload"
  force_destroy= true

  tags = {
    Environment = "Dev"
  }
}

resource "aws_iam_policy" "tf-upload-policy" {
  name        = "tf-upload-policy"
  path        = "/"
  description = "My test policy from terraform"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "s3:PutObject",
            "s3:GetObjectAcl",
            "s3:GetObject",
            "s3:RestoreObject",
            "s3:ListBucket",
            "s3:DeleteObject",
            "s3:GetBucketLocation",
            "s3:PutObjectAcl",
            "s3:GetObjectVersion",
            "s3:ListAllMyBuckets"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::cullen-tf-s3-bucket-123"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "tf-test-attachment"
  users      = [aws_iam_user.tf-file-upload.name]
  policy_arn = aws_iam_policy.tf-upload-policy.arn
}

# this wont work w/0 installing keybase download
resource "aws_iam_user_login_profile" "tf-file-upload" {
  user    = aws_iam_user.tf-file-upload.name
  pgp_key = "keybase:tf-file-upload"
}

output "password" {
  value = aws_iam_user_login_profile.tf-file-upload.encrypted_password
}