locals {
  waf_public_api_prefixes = [
    "/api/auth/",
    "/api/feed/public",
    "/api/fees",
  ]

  waf_cognito_operations = [
    "InitiateAuth",
    "RespondToAuthChallenge",
    "SignUp",
    "ConfirmSignUp",
    "ResendConfirmationCode",
    "ForgotPassword",
    "ConfirmForgotPassword",
  ]
}

resource "aws_wafv2_web_acl" "web" {
  provider    = aws.us_east_1
  name        = "${var.project_prefix}-web"
  description = "ReLoop 2: IP rate limits, bad IPs, common attack patterns - CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  custom_response_body {
    key          = "rate_limited"
    content_type = "APPLICATION_JSON"
    content      = jsonencode({ code = "RATE_LIMITED", message = "Too many requests - wait about 1 minute and try again" })
  }

  rule {
    name     = "rate-limit-public-api"
    priority = 0

    action {
      block {
        custom_response {
          response_code            = 429
          custom_response_body_key = "rate_limited"
          response_header {
            name  = "retry-after"
            value = "60"
          }
        }
      }
    }

    statement {
      rate_based_statement {
        limit                 = 100
        evaluation_window_sec = 60
        aggregate_key_type    = "IP"

        scope_down_statement {
          or_statement {
            dynamic "statement" {
              for_each = local.waf_public_api_prefixes
              content {
                byte_match_statement {
                  positional_constraint = "STARTS_WITH"
                  search_string         = statement.value
                  field_to_match {
                    uri_path {}
                  }
                  text_transformation {
                    priority = 0
                    type     = "LOWERCASE"
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-public-api"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "rate-limit-per-ip"
    priority = 1

    action {
      block {
        custom_response {
          response_code            = 429
          custom_response_body_key = "rate_limited"
          response_header {
            name  = "retry-after"
            value = "60"
          }
        }
      }
    }

    statement {
      rate_based_statement {
        limit                 = 1000
        evaluation_window_sec = 60
        aggregate_key_type    = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-per-ip"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"

        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }

        rule_action_override {
          name = "GenericRFI_BODY"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_prefix}-web"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl" "auth" {
  name        = "${var.project_prefix}-auth"
  description = "ReLoop 2: brute-force and sign-up spam protection - Cognito"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rate-limit-auth"
    priority = 0

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit                 = 300
        evaluation_window_sec = 300
        aggregate_key_type    = "IP"

        scope_down_statement {
          or_statement {
            dynamic "statement" {
              for_each = local.waf_cognito_operations
              content {
                byte_match_statement {
                  positional_constraint = "EXACTLY"
                  search_string         = statement.value
                  field_to_match {
                    single_header {
                      name = "x-amzn-cognito-operation-name"
                    }
                  }
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-auth"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_prefix}-auth"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "cognito" {
  resource_arn = aws_cognito_user_pool.main.arn
  web_acl_arn  = aws_wafv2_web_acl.auth.arn
}
