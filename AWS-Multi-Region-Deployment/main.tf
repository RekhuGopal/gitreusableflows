provider "aws" {
  region = var.aws_region
}

module "sns_topics" {
  source = "./SNS"
  aws_regions = var.aws_region
  aws_sns_topic_name = var.aws_sns_topic_name
}
