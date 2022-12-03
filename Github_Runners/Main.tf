terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
		}
	}

	backend "remote" {
		hostname = "app.terraform.io"
		organization = "CloudQuickLabs"

		workspaces {
			name = "EKS-Terraform"
		}
	}
}

provider "aws" {
	region = "eu-west-2"
}