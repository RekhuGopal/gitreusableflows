resource "aws_s3_bucket" "s3_bucket_2" {
  bucket        = "kinesis-bucket"
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
    Description = "Bucket for storing processed events for visualization features."
  }
}
