resource "aws_cloudwatch_event_rule" "fraud_detection_scheduled_rule" {
  name                = "fraud-detection-scheduled-rule"
  description         = "ScheduledRule"
  schedule_expression = "rate(1 minute)"
  is_enabled          = false

  tags = {
    Group     = "Demo"
    CreatedBy = "cQPOCs"
  }
}

resource "aws_cloudwatch_event_target" "fraud_detection" {
  target_id = "TargetFunctionV1"
  rule      = aws_cloudwatch_event_rule.fraud_detection_scheduled_rule.name
  arn       = aws_lambda_function.fraud_detection_event_processor.arn
}

resource "aws_lambda_permission" "fraud_detection" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fraud_detection_event_processor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.fraud_detection_scheduled_rule.arn
}
