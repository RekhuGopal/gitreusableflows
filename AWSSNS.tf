## SNS topic
resource "aws_sns_topic" "awssnstopic" {
    name = "cqpocs-topic"
}

## SQS Primary
resource "aws_sqs_queue" "cqpocs_queue" {
    name = "cqpocs-updates-queue"
    redrive_policy  = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.cqpocs_dl_queue.arn}\",\"maxReceiveCount\":5}"
    visibility_timeout_seconds = 300

    tags = {
        Environment = "dev"
    }
}

## SQS  DLQ
resource "aws_sqs_queue" "cqpocs_dl_queue" {
    name = "cqpocs-updates-dl-queue"
}

## SNS topic subscription
resource "aws_sns_topic_subscription" "cqpocs_updates_sqs_target" {
    topic_arn = aws_sns_topic.awssnstopic.arn
    protocol  = "sqs"
    endpoint  = aws_sqs_queue.cqpocs_queue.arn
}

## SQS Policy
resource "aws_sqs_queue_policy" "cqpocs_updates_queue_policy" {
    queue_url = aws_sqs_queue.cqpocs_queue.id
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.cqpocs_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.awssnstopic.arn}"
        }
      }
    }
  ]
}
POLICY
}
