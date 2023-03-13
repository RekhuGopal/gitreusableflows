provider "aws" {
  region = var.aws_region
}

module "sns_topics" {
  source = "AWS-Multi-Region-Deployment/SNS"
}
