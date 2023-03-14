provider "aws" {
  region = "us-east-1"
}

module "sns_topics" {
  source = "./SNS"

  aws_regions = var.aws_regions
  aws_sns_topic_name = var.aws_sns_topic_name
}
