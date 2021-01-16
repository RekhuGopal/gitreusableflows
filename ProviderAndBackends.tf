terraform {
  backend "remote" {
    organization = "CloudQuickPOCs"

    workspaces {
      name = "AWS-CloudQuickPOCs"
    }
  }
}
