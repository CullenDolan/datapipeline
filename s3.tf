# File to create an S3 bucket 
resource "aws_s3_bucket" "lscdatalake-dev" {
  bucket = "lscdatalake-dev"
  acl    = "private"

  tags = {
    Name        = "lscdatalake-dev"
    Environment = "TF-Dev"
  }
}
resource "aws_s3_bucket_object" "tbs-dev" {
  bucket  = aws_s3_bucket.lscdatalake-dev.id
  acl     = "private"
  key     = "tbs-dev/"
  content = ""

  tags = {
    Environment = "TF-Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "lscdatalake-dev" {
  bucket = aws_s3_bucket.lscdatalake-dev.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}