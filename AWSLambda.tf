##Zip the function to be run at function App.
data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/Project/hello.js"
  output_path = "${path.module}/hello.zip"
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
  key    = "hello.zip"
  source = "${path.module}/hello.zip"
}

## IAM role for lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = "${file("Project/lambda_assume_role_policy.json")}"
}

## IAM role-policy for lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_role.id
  policy = "${file("Project/lambda_policy.json")}"
}


## AWS lambda functions
resource "aws_lambda_function" "test_lambda" {
  function_name = "hello"
  s3_bucket     = aws_s3_bucket.cqpocsbucket.id
  s3_key        = "hello.zip"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello.handler"
  runtime       = "nodejs12.x"
}