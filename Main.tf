## backend data for terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "remote" {
  organization = "CloudQuickLabs"

    workspaces {
      name = "AWSBackup"
    }
  }
}

## test