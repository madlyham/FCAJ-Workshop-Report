resource "aws_budgets_budget" "monthly" {
  name             = "${var.project_prefix}-budget"
  budget_type      = "COST"
  limit_amount     = var.budget_limit_usd
  limit_unit       = "USD"
  time_unit        = "MONTHLY"
  time_period_start = var.budget_time_period_start
  metrics          = ["UnblendedCost"]
  billing_view_arn = "arn:aws:billing::${data.aws_caller_identity.current.account_id}:billingview/primary"

  filter_expression {
    not {
      dimensions {
        key    = "RECORD_TYPE"
        values = ["Credit", "Refund"]
      }
    }
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 85
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.alert_email]
  }
}

resource "aws_cloudwatch_log_metric_filter" "unhandled_errors" {
  name           = "${var.project_prefix}-UnhandledErrors"
  pattern        = "{ $.msg = \"unhandled_error\" }"
  log_group_name = aws_cloudwatch_log_group.api.name

  metric_transformation {
    name          = "UnhandledErrors"
    namespace     = "ReLoop/${var.project_prefix}"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_sns_topic" "alarms" {
  name         = "${var.project_prefix}-alarms"
  display_name = "ReLoop 2 Alarms"
}

resource "aws_sns_topic_subscription" "alarms_email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project_prefix}-lambda-errors"
  alarm_description   = "Lambda API errors (unhandled exception or timeout) >= 3 in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 3
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    FunctionName = aws_lambda_function.api.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "api_5xx" {
  alarm_name          = "${var.project_prefix}-api-5xx"
  alarm_description   = "API returned 5xx >= 5 times in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "5xx"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    ApiId = aws_apigatewayv2_api.http.id
  }
}

resource "aws_cloudwatch_dashboard" "backend_health" {
  dashboard_name = "ReLoop2-Backend-Health"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.api.function_name, { region = data.aws_region.current.region, stat = "Sum" }],
            [".", "Errors", ".", ".", { region = data.aws_region.current.region, stat = "Sum" }],
            [".", "Throttles", ".", ".", { region = data.aws_region.current.region, stat = "Sum" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.region
          period  = 300
          title   = "Lambda API (${aws_lambda_function.api.function_name})"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiId", aws_apigatewayv2_api.http.id, { region = data.aws_region.current.region, stat = "Sum" }],
            [".", "4xx", ".", ".", { region = data.aws_region.current.region, stat = "Sum" }],
            [".", "5xx", ".", ".", { region = data.aws_region.current.region, stat = "Sum" }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.region
          period  = 300
          title   = "HTTP API (${aws_apigatewayv2_api.http.id})"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 24
        height = 4
        properties = {
          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", aws_dynamodb_table.core.name],
            [".", "ConsumedWriteCapacityUnits", ".", "."]
          ]
          sparkline = true
          view      = "singleValue"
          region    = data.aws_region.current.region
          stat      = "Sum"
          period    = 300
          title     = "DynamoDB Capacity (${aws_dynamodb_table.core.name})"
        }
      }
    ]
  })
}
