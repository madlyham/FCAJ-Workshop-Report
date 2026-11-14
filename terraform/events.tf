resource "aws_cloudwatch_event_rule" "sweep" {
  name                = "${var.project_prefix}-sweep"
  description         = "ReLoop 2: expire listings, send 24h reminders, auto-complete 48h"
  schedule_expression = "rate(15 minutes)"
  state               = "ENABLED"
}

resource "aws_cloudwatch_event_target" "sweep_lambda" {
  rule      = aws_cloudwatch_event_rule.sweep.name
  target_id = "Id769d420f-b9ed-4004-8bed-d1c646ca5cfc"
  arn       = aws_lambda_function.api.arn
}

resource "aws_lambda_permission" "eventbridge_sweep" {
  statement_id  = "AWSEvents_${var.project_prefix}-sweep_Id769d420f-b9ed-4004-8bed-d1c646ca5cfc"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sweep.arn
}
