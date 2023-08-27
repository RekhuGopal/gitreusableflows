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
			name = "AWSEKS"
		}
	}
}

provider "aws" {
	region = "us-west-2"
}
