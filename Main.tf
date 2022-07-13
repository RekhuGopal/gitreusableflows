## backend data for terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "remote" {
  organization = "cloudquicklabs"

    workspaces {
      name = "AWSBackup"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
