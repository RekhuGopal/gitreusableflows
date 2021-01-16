provider "aws" {
  region = "us-east-1"
}

provider "random" {}

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

