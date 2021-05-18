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