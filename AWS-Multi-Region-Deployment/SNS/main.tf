resource "aws_sns_topic" "example" {
  count          = length(var.aws_regions)
  name           = "example-topic-${var.aws_regions[count.index]}"
  display_name   = "Example SNS Topic"
  provider       = aws.regions[var.aws_regions[count.index]]
}

output "sns_topic_arns" {
  value = aws_sns_topic.example.*.arn
}