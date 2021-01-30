resource "aws_cloudformation_stack" "network" {
  name = "networking-stack"

  parameters = {
    BucketName = "quickcloudpoccloudformationdemobucket"
  }

  template_body = file("CloudFormationTemplates/S3.yaml")
}