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
			name = "AWSBackup"
		}
	}
}

provider "aws" {
  version = "~> 2.44"
  region  = var.region
}

provider "local" {
  version = "~> 1.4"
}

provider "template" {
  version = "~> 2.1"
}

provider "external" {
  version = "~> 1.2"
}

provider "kubernetes" {
  load_config_file       = false
  version                = "~> 1.10"
}

#module "vpc" {
# source             = "./vpc"
#  name               = var.name
#  environment        = var.environment
#  cidr               = var.cidr
#  private_subnets    = var.private_subnets
#  public_subnets     = var.public_subnets
#  availability_zones = var.availability_zones
#}

module "eks" {
#  source          = "./eks"
#  name            = var.name
#  environment     = var.environment
#  region          = var.region
#  k8s_version     = var.k8s_version
#  vpc_id          = module.vpc.id
#  private_subnets = module.vpc.private_subnets
#  public_subnets  = module.vpc.public_subnets
#  kubeconfig_path = var.kubeconfig_path
#}

#module "ingress" {
#  source       = "./ingress"
#  name         = var.name
#  environment  = var.environment
#  region       = var.region
#  vpc_id       = module.vpc.id
#  cluster_id   = module.eks.cluster_id
#}