## DynamoDB table creation
resource "aws_dynamodb_table" "cqpocs-dynamodb-table" {
  name           = "IndianSongs"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "Artist"
  range_key      = "Song Title"

  attribute {
    name = "Artist"
    type = "S"
  }

  attribute {
    name = "Song Title"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}