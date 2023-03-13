provider "aws" {
  for_each = var.aws_regions

  region = each.value
}

module "sns_topics" {
  source = "./SNS"
  for_each = var.regions

  aws_region = each.value
  aws_sns_topic_name = var.aws_sns_topic_name
}
