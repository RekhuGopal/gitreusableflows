resource "aws_iam_role" "fraud_detection_firehose_role" {
  name = "fraud-detection-firehose-role"

  tags = {
    Group     = "DemoSagemakers"
    CreatedBy = "CQPOCs"
  }

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "firehose.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "fraud_detection_firehose" {
  role       = aws_iam_role.fraud_detection_firehose_role.name
  policy_arn = aws_iam_policy.fraud_detection_firehose_policy.arn
}

resource "aws_iam_policy" "fraud_detection_firehose_policy" {
  name        = "fraud-detection-firehose-policy"
  description = "Policy for the Amazon Kinesis Data Firehose to save data to S3 bucket"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.s3_bucket_2.id}",
                "arn:aws:s3:::${aws_s3_bucket.s3_bucket_2.id}/kin*"
            ]
        }
    ]
}
EOF
}
