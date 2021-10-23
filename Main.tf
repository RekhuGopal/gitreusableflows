## backend data for terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
  organization = "CloudQuickPOCs"

    workspaces {
      name = "AWS-CloudQuickPOCs"
    }
  }
}

## random provider
provider "random" {}

## Provider us-east-1
provider "aws" {
  region = "us-east-1"
}

