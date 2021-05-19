resource "aws_iam_user" "DataLoadUser" {
  name = "DataLoadUser"
  force_destroy= true

  tags = {
    Environment = "TF-Dev"
  }
}

resource "aws_iam_policy" "DataLoadUserPolicy" {
  name        = "DataLoadUserPolicy"
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
        Resource = "arn:aws:s3:::lscdatalake-dev"
      },
    ]
  })

  tags = {
    Environment = "TF-Dev"
  }
}

resource "aws_iam_policy_attachment" "AttachPolicytoUser" {
  name       = "AttachPolicytoUser"
  users      = [aws_iam_user.DataLoadUser.name]
  policy_arn = aws_iam_policy.DataLoadUserPolicy.arn
}


resource "aws_iam_role" "RDStoS3Role" {
  name = "RDStoS3Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:GetObjectVersion",
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:ListJobs"
            ]
            Effect = "Allow"
            Resource = [
                "arn:aws:s3:::lscdatalake-dev",
                "arn:aws:s3:::lscdatalake-dev/*"
            ]
        },
    ]
  })

  tags = {
    Environment = "TF-Dev"
  }
}

// # add this once keybase is figured out
// resource "aws_iam_user_login_profile" "DataLoadUserLogin" {
//   user    = aws_iam_user.DataLoadUser.name
//   pgp_key = "keybase:some_person_that_exists"
// }