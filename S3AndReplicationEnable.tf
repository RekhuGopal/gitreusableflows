## Provider us-east-1
provider "aws" {
  region = "us-east-1"
}

## Provider us-west-1
provider "aws" {
  alias  = "central"
  region = "us-west-1"
}

## AWS IAM ROLE
resource "aws_iam_role" "replication" {
  name = "tf-iam-role-replication-cloudquickpocs"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

## AWS IAM Policy
resource "aws_iam_policy" "replication" {
  name = "tf-iam-role-policy-replication-cloudquickpocs"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.destination.arn}/*"
    }
  ]
}
POLICY
}

## AWS IAM policy and Role attachment
resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


## Replication Destination S3
resource "aws_s3_bucket" "destination" {
  bucket = "tf-bucket-destination-cloudquickpocs"

  versioning {
    enabled = true
  }
}


## AWS S3 for source
resource "aws_s3_bucket" "bucket" {
  provider = aws.central
  bucket   = "tf-bucket-cloudquickpocs"
  acl      = "private"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "foobar"
      prefix = "foo"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.destination.arn
        storage_class = "STANDARD"
      }
    }
  }
}