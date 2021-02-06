##Zip the function to be run at function App.
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/Lambda/example.js"
  output_path = "${path.module}/Lambda/example.zip"
}

## S3 Bucket
resource "aws_s3_bucket" "cqpocsbucket" {
  bucket = "quickcloudpocsbucket001"
  acl    = "private"

  tags = {
    Name        = "cqpocsbucket-1"
  }
}

## Upload zip file to s3 bucket
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.cqpocsbucket.id
  key    = "example.zip"
  source = "${path.module}/Lambda/example.zip"
}

## AWS Lambda function
resource "aws_lambda_function" "results_updates_lambda" {
    function_name    = "example"
    s3_bucket        = aws_s3_bucket.cqpocsbucket.id
    s3_key           = "example.zip"
    role             = aws_iam_role.lambda_role.arn
    handler          = "example.handler"
    runtime          = "nodejs12.x"
}

## AWS IAM Role
resource "aws_iam_role" "lambda_role" {
    name = "LambdaRole"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        }
    }
  ]
}
EOF
}

# AWS IAM Role SQS Policy
resource "aws_iam_role_policy" "lambda_role_sqs_policy" {
    name = "AllowSQSPermissions"
    role = aws_iam_role.lambda_role.id
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# AWS IAM Role Logs Policy
resource "aws_iam_role_policy" "lambda_role_logs_policy" {
    name = "LambdaRolePolicy"
    role = aws_iam_role.lambda_role.id
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

## Data of SQS
data "aws_sqs_queue" "cqpocs_queue" {
    name = "cqpocs-updates-queue"
}

## Event Source mapping
resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = data.aws_sqs_queue.cqpocs_queue.arn
  function_name    = aws_lambda_function.results_updates_lambda.arn
}