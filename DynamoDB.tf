## DynamoDB table creation
resource "aws_dynamodb_table" "cqpocs-dynamodb-table" {
  name           = "BusinessPerformance"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "BusinessId"
  range_key      = "BusinesTitle"

  attribute {
    name = "BusinessId"
    type = "S"
  }

  attribute {
    name = "BusinesTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}