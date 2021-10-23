resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-cqpocs"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}