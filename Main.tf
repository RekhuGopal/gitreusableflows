## backend data for terraform
terraform {
  # Terraform version at the time of writing this post
  required_version = ">= 0.12.24"

  backend "s3" {
    bucket = "cloudquickpocsbackendtf"
    key    = "quickcloudpocsbackend_2.tfstate"
    region = "us-east-1"
  }
}

## random provider
provider "random" {}

## Provider us-east-1
provider "aws" {
  region = "us-east-1"
}

