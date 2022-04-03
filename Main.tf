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
  organization = "CloudQuickLabs"

    workspaces {
      name = "AWSBackup"
    }
  }
}

## random provider
provider "random" {}

## Provider us-east-1
provider "aws" {
  profile = "default"
  region = "us-east-1"
}