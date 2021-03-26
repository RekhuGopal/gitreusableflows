resource "aws_lambda_layer_version" "lambda_layer_creation" {
  filename   = "${path.module}/Modules/requests-2.7.0.zip"
  layer_name = "requestmodulelayer"

  compatible_runtimes = ["python3.6","python3.7","python3.8"]
}

##