terraform {
  # Terraform version at the time of writing this post
  required_version = "0.13.5"

  backend "s3" {
    bucket = "cloudquickpocsbackendtf"
    key    = "quickcloudpocsbackend.tfstate"
    region = "us-east-1"
  }
}

## random provider
provider "random" {}

## Provider us-east-1
provider "aws" {
  region = "us-east-1"
}

## Provider us-west-1
provider "aws" {
  alias  = "central"
  region = "us-west-1"
}

