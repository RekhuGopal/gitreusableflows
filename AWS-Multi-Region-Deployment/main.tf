provider "aws" {
  region = var.aws_region
}

module "sns_topics" {
  source = "./SNS"
}
