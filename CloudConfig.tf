## IAM role
resource "aws_iam_role" "cqpoc-config" {
  name = "config-cqpoc"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

## Attaching policy to above role
resource "aws_iam_role_policy_attachment" "my-config" {
  role       = aws_iam_role.cqpoc-config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

## AWS S3 bucket
resource "aws_s3_bucket" "cqpocs-config" {
  bucket = "config-bucket-cqpocs"
  acl    = "private"

  versioning {
    enabled = true
  }
}

## AWS Config recorder
resource "aws_config_configuration_recorder" "cqpoc-config" {
  name     = "config-cqpoc"
  role_arn = aws_iam_role.cqpoc-config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

## AWS Config deivery channel
resource "aws_config_delivery_channel" "cqpoc-config" {
  name           = "config-cqpoc"
  s3_bucket_name = aws_s3_bucket.cqpoc-config.bucket

  depends_on = ["aws_config_configuration_recorder.cqpoc-config"]
}

## AWS Config recording status
resource "aws_config_configuration_recorder_status" "config" {
  name       = aws_config_configuration_recorder.cqpoc-config.name
  is_enabled = true

  depends_on = ["aws_config_delivery_channel.cqpoc-config"]
}

## AWS Config rule for S3 bucket version check
resource "aws_config_config_rule" "s3_bucket_versioning_enabled" {
  name = "s3_bucket_versioning_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.cqpoc-config"]
}
