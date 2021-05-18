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