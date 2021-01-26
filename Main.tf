terraform {
  # Terraform version at the time of writing this post
  required_version = ">= 0.12.24"

  backend "s3" {
    bucket = "cloudquickpocsbackendtf"
    key    = "quickcloudpocsbackend.tfstate"
    region = "us-east-1"
  }
}

provider "random" {}

## Provider us-east-1
provider "aws" {
  region = "us-east-1"
}

## Provider us-west-1
provider "aws" {
  alias  = "central"
  region = "us-west-1"
}

## Create AWS Python lambda function
module "awslambdafunction" {
  source = "./LambdaFunction"
}

## Create AWS Stepfunction to Invoke AWS Lambda Function
module "awsstepfunction" {
  source         = "./StepFunction"
  pythonfunctionapparn = module.awslambdafunction.pythonLambdaArn
}