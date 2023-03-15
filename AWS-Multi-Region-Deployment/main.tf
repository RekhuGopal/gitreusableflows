module "us-east-1" {
  source = "./SNS"

  aws_region = "us-east-1"
  aws_sns_topic_name = var.aws_sns_topic_name
}

module "us-east-2" {
  source = "./SNS"

  aws_region = "us-east-2"
  aws_sns_topic_name = var.aws_sns_topic_name
  providers = {
    aws = "aws.us-east-2"
   }
}


module "us-west-1" {
  source = "./SNS"

  aws_region = "us-west-1"
  aws_sns_topic_name = var.aws_sns_topic_name
  providers = {
    aws = "aws.us-west-1"
   }
}

module "us-west-2" {
  source = "./SNS"

  aws_region = "us-west-2"
  aws_sns_topic_name = var.aws_sns_topic_name
  providers = {
    aws = "aws.us-west-2"
   }
}