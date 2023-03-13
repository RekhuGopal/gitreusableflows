module "sns_topics" {
  source = "./SNS"
  aws_region = var.region
  aws_regions = var.aws_region
  aws_sns_topic_name = var.aws_sns_topic_name
}
