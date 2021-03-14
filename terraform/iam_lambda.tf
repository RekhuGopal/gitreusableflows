data "aws_caller_identity" "current" {}

resource "aws_iam_role" "fraud_detection_lambda_role" {
  name = "fraud-detection-lambda-role"

  tags = {
    Group     = "DemoLambdaForSagemaker"
    CreatedBy = "CQPOCs"
  }

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "fraud_detection_lambda" {
  role       = aws_iam_role.fraud_detection_lambda_role.name
  policy_arn = aws_iam_policy.fraud_detection_lambda_policy.arn
}

resource "aws_iam_policy" "fraud_detection_lambda_policy" {
  name        = "fraud-detection-lambda-policy"
  description = "Policy for the fraud detection function to put records into the Amazon Kinesis Data Firehose"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sagemaker:InvokeEndpoint"
            ],
            "Resource": [
                "arn:aws:sagemaker:*:*:endpoint/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource":  [
                "${aws_kinesis_firehose_delivery_stream.fraud_detection_firehose_stream.arn}"
            ]
        }
    ]
}
EOF
}
