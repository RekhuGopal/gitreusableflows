data "aws_caller_identity" "current" {}

# -----------------------------------------------------------
# setup permissions to allow cloudtrail to write to cloudwatch
# -----------------------------------------------------------
resource "aws_iam_role" "cloudtrail_cqpocsrole" {
  name = "cloudtrail-to-cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudtrail_cqpocsrolepolicy" {
  name = "cloudtrail-policy"
  role = aws_iam_role.cloudtrail_cqpocsrole.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": ["logs:CreateLogStream"],
      "Resource": [
        "arn:aws:logs:us-east-1:357171621133:log-group:${aws_cloudwatch_log_group.awss3bucketloggroups.id}:log-stream:*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": ["logs:PutLogEvents"],
      "Resource": [
        "arn:aws:logs:us-east-1:357171621133:log-group:${aws_cloudwatch_log_group.awss3bucketloggroups.id}:log-stream:*"
      ]
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "awss3bucketloggroups" {
  name = "log-stream"
}

resource "aws_cloudtrail" "awscloudtrailcqpocs" {
  name                          = "tf-based-cloud-trail"
  s3_bucket_name                = aws_s3_bucket.cqpocs.id
  s3_key_prefix                 = "cloudtrailkey"
  include_global_service_events = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.awscloudtrailcqpocs.arn
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
 cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cqpocsrole.arn # CloudTrail requires the Log Stream wildcard
}

resource "aws_s3_bucket" "cqpocs" {
  bucket        = "tf-test-trail-bucket-cqpocs"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::tf-test-trail-bucket-cqpocs"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::tf-test-trail-bucket-cqpocs/cloudtrailkey/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}