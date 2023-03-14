resource "aws_sns_topic" "example" {
  for_each = var.aws_regions

  name           = "${var.aws_sns_topic_name}-${each.value}"
  display_name   = "Multi Region SNS Topic"
}

output "sns_topic_arns" {
  value = aws_sns_topic.example.*.arn
}