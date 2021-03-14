resource "aws_s3_bucket" "s3_bucket_1" {
  bucket        = "fdsagemaker-bucket"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Description = "Bucket for storing the Amazon SageMaker model and training data."
  }
}

resource "aws_s3_bucket_object" "s3_fraud_detection_notebook" {
  bucket = aws_s3_bucket.fraud_detection_function_bucket.id
  key    = "fraud-detection-using-machine-learning/1.0/notebooks/sagemaker_fraud_detection.ipynb"
  source = "source/notebooks/sagemaker_fraud_detection.ipynb"
}
