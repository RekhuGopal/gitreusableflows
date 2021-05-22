## DynamoDB table creation
resource "aws_dynamodb_table" "cqpocs-dynamodb-table" {
  name           = "BusinessPerformance"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "BusinessOwnerId"
  range_key      = "BusinessTitle"

  attribute {
    name = "BusinessOwnerId"
    type = "S"
  }

  attribute {
    name = "BusinessTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "BusinessTitleIndex"
    hash_key           = "BusinessTitle"
    range_key          = "TopScore"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["BusinessOwnerId"]
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}