resource "aws_s3_bucket" "fraud_detection_function_bucket" {
  bucket = "fdcqpocs-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Description = "Bucket hosting the code for fraud_detection Lambda function."
  }
}

data "archive_file" "fraud_detection_archive" {
  type        = "zip"
  source_file = file("source/fraud_detection/index.py")
  output_path = "${path.module}/dist/fraud_detection.zip"
}

resource "aws_s3_bucket_object" "s3_fraud_detection_archive" {
  bucket = aws_s3_bucket.fraud_detection_function_bucket.id
  key    = "fraud-detection-using-machine-learning/1.0/fraud_detection.zip"
  source = data.archive_file.fraud_detection_archive.output_path
}
