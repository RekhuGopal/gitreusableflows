resource "aws_sagemaker_notebook_instance" "basic" {
  name                  = "FraudDetectionNotebookInstance"
  role_arn              = aws_iam_role.sm_notebook_instance_role.arn
  instance_type         = "ml.t3.medium"
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.basic_lifecycle.name

  tags = {
    Group     = "Demo"
    CreatedBy = "CQPOCs"
  }

  depends_on = [aws_s3_bucket_object.s3_bucket_1]
}

data "template_file" "instance_init" {
  template = file("terraform/template/sagemaker_instance_init.sh")

  vars = {
    s3_bucket_name_1     = aws_s3_bucket.s3_bucket_1.id
    aws_region           = "us-east-1"
    function_bucket_name = "fdsagemaker-bucket"
    function_version     = "1.0"
  }
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "basic_lifecycle" {
  name     = "BasicNotebookInstanceLifecycleConfig"
  on_start = base64encode(data.template_file.instance_init.rendered)

  depends_on = [aws_s3_bucket.s3_bucket_1]
}
