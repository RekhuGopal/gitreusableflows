resource "aws_lambda_function" "fraud_detection_event_processor" {
  handler       = "index.lambda_handler"
  function_name = "fraud-detection-event-processor"
  role          = aws_iam_role.fraud_detection_lambda_role.arn
  s3_bucket     = aws_s3_bucket.fraud_detection_function_bucket.id
  s3_key        = "fraud-detection-using-machine-learning/1.0/fraud_detection.zip"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(data.archive_file.fraud_detection_archive.output_path)

  runtime = "python3.6"

  tags = {
    Group     = "sagelambda"
    CreatedBy = "CQPOCs"
  }

  depends_on = [aws_s3_bucket_object.s3_fraud_detection_archive]
}
