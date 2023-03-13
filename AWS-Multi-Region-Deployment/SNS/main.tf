resource "aws_sns_topic" "example" {
  count          = length(var.aws_regions)
  name           = "${var.aws_sns_topic_name}-${var.aws_regions[count.index]}"
  display_name   = "Multi Region SNS Topic"
  provider       = aws.regions[var.aws_regions[count.index]]
}

output "sns_topic_arns" {
  value = aws_sns_topic.example.*.arn
}