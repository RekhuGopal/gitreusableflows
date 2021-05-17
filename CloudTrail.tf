data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "awss3bucketloggroups" {
  name = "s3-bucketlog-group"
}

resource "aws_cloudtrail" "awscloudtrailcqpocs" {
  name                          = "tf-based-cloud-trail"
  include_global_service_events = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.awss3bucketloggroups.arn}:*" # CloudTrail requires the Log Stream wildcard
}