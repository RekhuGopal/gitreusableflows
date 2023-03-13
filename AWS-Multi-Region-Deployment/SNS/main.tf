resource "aws_sns_topic" "example" {
  name           = "${var.aws_sns_topic_name}-${var.region}"
  display_name   = "Multi Region SNS Topic"
}

output "sns_topic_arns" {
  value = aws_sns_topic.example.*.arn
}