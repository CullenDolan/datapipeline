# create a user for uploading data to s3
# maybe swith this to a role?
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

# rds policy
resource "aws_iam_policy" "RDSAccessS3wTF"{
  name        = "RDSAccessS3wTF"
  path        = "/"
  description = "Policy created w/ terraform to attach to an RDS instance, that will get data from an s3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::cullenbucketfordb",
          "arn:aws:s3:::lscdatalake-dev",
          "arn:aws:s3:::cullenbucketfordb/*",
          "arn:aws:s3:::lscdatalake-dev/*"
        ]
      },
    ]
  })
  tags = {
    Environment = "TF-Dev"
  }
}

# rds role
resource "aws_iam_role" "RDSImportS3roleTF"{
  name    = "RDSImportS3roleTF"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
# attach role to instance
resource "aws_iam_policy_attachment" "AttachPolicytoRDS" {
  name  = "AttachPolicytoRDS"
  roles = [aws_iam_role.RDSImportS3roleTF.name]
  policy_arn = aws_iam_policy.RDSAccessS3wTF.arn
}

// # resource association
// resource "aws_db_instance_role_association" "AssociateRolewRDSTF" {
//   db_instance_identifier = aws_db_instance.lscdevdbinstance.id
//   feature_name           = "s3Import"
//   role_arn               = aws_iam_role.RDSImportS3roleTF.arn
// }

// # add this once keybase is figured out
// resource "aws_iam_user_login_profile" "DataLoadUserLogin" {
//   user    = aws_iam_user.DataLoadUser.name
//   pgp_key = "keybase:some_person_that_exists"
// }