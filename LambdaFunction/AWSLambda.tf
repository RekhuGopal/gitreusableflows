##Zip the function to be run at function App.	
data "archive_file" "init" {	
  type        = "zip"	
  source_file = "${path.module}/Example.py"
  output_path = "${path.module}/Example.zip"	
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
  key    = "Example.zip"	
  source = "${path.module}/Example.zip"	
}	

## IAM role for lambda	
resource "aws_iam_role" "lambda_role" {	
  name               = "lambda_role"	
  assume_role_policy = file("LambdaFunction/lambda_assume_role_policy.json")	
}	

## IAM role-policy for lambda	
resource "aws_iam_role_policy" "lambda_policy" {	
  name   = "lambda_policy"	
  role   = aws_iam_role.lambda_role.id	
  policy = file("LambdaFunction/lambda_policy.json")	
}	


## AWS lambda functions	
resource "aws_lambda_function" "test_lambda" {	
  function_name = "Example"	
  s3_bucket     = aws_s3_bucket.cqpocsbucket.id	
  s3_key        = "Example.zip"	
  role          = aws_iam_role.lambda_role.arn	
  handler       = "Example.handler"	
  runtime       = "python3.8"	
}

## output to be consumed by other module
output "pythonLambdaArn" {
  value = aws_lambda_function.test_lambda.arn
}