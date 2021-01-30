resource "aws_cloudformation_stack" "s3staticwebsite" {
  name = "s3staticwebsite-stack"

  parameters = {
    BucketName = "quickcloudpoccloudformationdemobucket1"
  }

  template_body = file("CloudFormationTemplates/S3.yaml")
}