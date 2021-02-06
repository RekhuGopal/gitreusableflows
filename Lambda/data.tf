data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/Lambda/example.js"
  output_path = "${path.module}/Lambda/example.zip"
}