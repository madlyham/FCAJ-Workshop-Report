resource "aws_iam_role" "api" {
  name                 = "${var.project_prefix}-api-lambda-role"
  description          = "ReLoop 2 API Lambda - DynamoDB, S3 photos, Bedrock, Rekognition, Cognito alias check"
  permissions_boundary = var.role_permissions_boundary_name != "" ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.role_permissions_boundary_name}" : null
  tags                 = var.common_tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_basic" {
  role       = aws_iam_role.api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "api_access" {
  name = "${var.project_prefix}-api-access"
  role = aws_iam_role.api.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CoreTable"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:ConditionCheckItem"
        ]
        Resource = [
          aws_dynamodb_table.core.arn,
          "${aws_dynamodb_table.core.arn}/index/*"
        ]
      },
      {
        Sid    = "ListingImages"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:PutObjectTagging",
          "s3:GetObjectTagging",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.images.arn}/listings/*"
      },
      {
        Sid    = "Bedrock"
        Effect = "Allow"
        Action = ["bedrock:InvokeModel"]
        Resource = [
          "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:inference-profile/${var.ai_model_id}",
          "arn:aws:bedrock:*::foundation-model/*"
        ]
      },
      {
        Sid    = "Guardrail"
        Effect = "Allow"
        Action = ["bedrock:ApplyGuardrail"]
        Resource = [
          "arn:aws:bedrock:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:guardrail/*",
          "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:guardrail-profile/*"
        ]
      },
      {
        Sid    = "Moderation"
        Effect = "Allow"
        Action = [
          "rekognition:DetectModerationLabels",
          "rekognition:DetectText"
        ]
        Resource = "*"
      },
      {
        Sid      = "SelfInvoke"
        Effect   = "Allow"
        Action   = ["lambda:InvokeFunction"]
        Resource = "arn:aws:lambda:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:function:${var.project_prefix}-api"
      },
      {
        Sid      = "CognitoAliasCheck"
        Effect   = "Allow"
        Action   = ["cognito-idp:ListUsers"]
        Resource = aws_cognito_user_pool.main.arn
      },
      {
        Sid    = "Logs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_prefix}-api:*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/aws/lambda/${var.project_prefix}-api"
  retention_in_days = 7
}

resource "aws_lambda_function" "api" {
  function_name    = "${var.project_prefix}-api"
  description      = "ReLoop 2 backend API (workshop)"
  role             = aws_iam_role.api.arn
  filename         = var.api_zip_path
  source_code_hash = filebase64sha256(var.api_zip_path)
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  architectures    = ["arm64"]
  memory_size      = 512
  timeout          = 180
  tags             = var.common_tags

  environment {
    variables = {
      AI_GUARDRAIL_ID      = aws_bedrock_guardrail.main.guardrail_id
      AI_GUARDRAIL_VERSION = aws_bedrock_guardrail_version.v1.version
      AI_MODEL_ID          = var.ai_model_id
      AUTH_MODE            = "cognito"
      BILLING_ACCOUNT_NAME = var.billing_account_name
      BILLING_ACCOUNT_NO   = var.billing_account_no
      BILLING_BANK_NAME    = var.billing_bank_name
      COGNITO_CLIENT_ID    = aws_cognito_user_pool_client.web.id
      IMAGE_BUCKET         = aws_s3_bucket.images.bucket
      NODE_OPTIONS         = "--enable-source-maps"
      ORIGIN_VERIFY_SECRET = var.origin_verify_secret
      STAGE                = "aws"
      TABLE_NAME           = aws_dynamodb_table.core.name
    }
  }

  depends_on = [aws_cloudwatch_log_group.api]
}

resource "aws_apigatewayv2_api" "http" {
  name          = "${var.project_prefix}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers     = ["authorization", "idempotency-key", "content-type"]
    allow_methods     = ["*"]
    allow_origins = concat(["http://localhost:5173"], var.cloudfront_cors_origins)
    max_age = 3600
  }
}

resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id           = aws_apigatewayv2_api.http.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.web.id]
    issuer   = "https://${aws_cognito_user_pool.main.endpoint}"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    detailed_metrics_enabled = false
    throttling_burst_limit   = 50
    throttling_rate_limit    = 20
  }
}

locals {
  api_routes = {
    "POST /auth/session" = { auth = "NONE", perm_path = "/auth/session" }
    "POST /auth/logout"  = { auth = "NONE", perm_path = "/auth/logout" }
    "POST /auth/refresh" = { auth = "NONE", perm_path = "/auth/refresh" }
    "GET /feed/public"   = { auth = "NONE", perm_path = "/feed/public" }
    "GET /fees"          = { auth = "NONE", perm_path = "/fees" }
    "OPTIONS /{proxy+}"  = { auth = "NONE", perm_path = null }
    "ANY /{proxy+}"      = { auth = "JWT",  perm_path = "/{proxy+}" }
  }
}

resource "aws_apigatewayv2_integration" "routes" {
  for_each = local.api_routes

  api_id                 = aws_apigatewayv2_api.http.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.api.arn
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

resource "aws_apigatewayv2_route" "routes" {
  for_each = local.api_routes

  api_id             = aws_apigatewayv2_api.http.id
  route_key          = each.key
  authorization_type = each.value.auth
  authorizer_id      = each.value.auth == "JWT" ? aws_apigatewayv2_authorizer.cognito.id : null
  target             = "integrations/${aws_apigatewayv2_integration.routes[each.key].id}"
}

resource "aws_lambda_permission" "apigw_routes" {
  for_each = { for k, v in local.api_routes : k => v if v.perm_path != null }

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http.execution_arn}/*/*${each.value.perm_path}"
}
