# create a user for uploading
resource "aws_iam_user" "DataLoadUser" {
  name          = "DataLoadUser"
  force_destroy = true

  tags = {
    Environment = "TF-Dev"
  }
}

# policy to give the user access to s3
resource "aws_iam_policy" "DataLoadUserPolicy" {
  name        = "DataLoadUserPolicy"
  path        = "/"
  description = "My test policy from terraform"

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
        Resource = "arn:aws:s3:::lscdatalake-dev"
      },
    ]
  })

  tags = {
    Environment = "TF-Dev"
  }
}

# attach policy to user
resource "aws_iam_policy_attachment" "AttachPolicytoUser" {
  name       = "AttachPolicytoUser"
  users      = [aws_iam_user.DataLoadUser.name]
  policy_arn = aws_iam_policy.DataLoadUserPolicy.arn
}

// giving rds access to s3 isnt working
// # add this once keybase is figured out
// resource "aws_iam_user_login_profile" "DataLoadUserLogin" {
//   user    = aws_iam_user.DataLoadUser.name
//   pgp_key = "keybase:some_person_that_exists"
// }