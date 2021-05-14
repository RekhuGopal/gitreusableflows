data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "awscloudtrailcqpocs" {
  name                          = "tf-based-cloud-trail"
  s3_bucket_name                = aws_s3_bucket.cqpocs.id
  s3_key_prefix                 = "cloudtrailkey"
  include_global_service_events = true
}

resource "aws_s3_bucket" "cqpocs" {
  bucket        = "tf-test-trail-bucket"
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
            "Resource": "arn:aws:s3:::tf-test-trail-bucket"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::tf-test-trail-bucket/cloudtrailkey/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
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