resource "aws_iam_role" "post_confirmation" {
  name                 = "${var.project_prefix}-post-confirmation-role"
  description          = "ReLoop 2 post-confirmation Lambda: write new user profile to DynamoDB"
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

resource "aws_iam_role_policy_attachment" "post_confirmation_basic" {
  role       = aws_iam_role.post_confirmation.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "post_confirmation_dynamodb" {
  name = "DynamoDBWriteAccess"
  role = aws_iam_role.post_confirmation.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "PutUserProfile"
        Effect   = "Allow"
        Action   = "dynamodb:PutItem"
        Resource = aws_dynamodb_table.core.arn
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "post_confirmation" {
  name = "/aws/lambda/${var.project_prefix}-post-confirmation"
}

resource "aws_lambda_function" "post_confirmation" {
  function_name    = "${var.project_prefix}-post-confirmation"
  role             = aws_iam_role.post_confirmation.arn
  filename         = var.post_confirmation_zip_path
  source_code_hash = filebase64sha256(var.post_confirmation_zip_path)
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  architectures    = ["x86_64"]
  memory_size      = 128
  timeout          = 3
  tags             = var.common_tags

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.core.name
    }
  }

  depends_on = [aws_cloudwatch_log_group.post_confirmation]
}

resource "aws_cognito_user_pool" "main" {
  name                     = "${var.project_prefix}-user-pool"
  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]
  deletion_protection      = "ACTIVE"
  mfa_configuration        = "OFF"
  user_pool_tier           = "ESSENTIALS"
  tags                     = var.common_tags

  username_configuration {
    case_sensitive = false
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  sign_in_policy {
    allowed_first_auth_factors = ["PASSWORD"]
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "ReLoop - mã xác minh tài khoản"
    email_message        = "Mã xác minh ReLoop của bạn là {####}"
    sms_message          = "Your verification code is {####}."
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = "0"
      max_length = "2048"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "address"
    required                 = true

    string_attribute_constraints {
      min_length = "0"
      max_length = "2048"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "phone_number"
    required                 = true

    string_attribute_constraints {
      min_length = "0"
      max_length = "2048"
    }
  }

  lambda_config {
    pre_sign_up       = "arn:aws:lambda:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:function:${var.project_prefix}-api"
    post_confirmation = aws_lambda_function.post_confirmation.arn
  }
}

resource "aws_cognito_user_pool_client" "web" {
  name                                          = "${var.project_prefix}-web-client"
  user_pool_id                                  = aws_cognito_user_pool.main.id
  explicit_auth_flows                           = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  supported_identity_providers                  = ["COGNITO"]
  allowed_oauth_flows_user_pool_client          = true
  allowed_oauth_flows                           = ["code"]
  allowed_oauth_scopes                          = ["email", "openid", "phone"]
  callback_urls                                 = ["http://localhost:5173/auth/callback", "https://${aws_cloudfront_distribution.web.domain_name}/auth/callback"]
  logout_urls                                   = ["http://localhost:5173/", "https://${aws_cloudfront_distribution.web.domain_name}/"]
  access_token_validity                         = 60
  id_token_validity                             = 60
  refresh_token_validity                        = 5
  prevent_user_existence_errors                 = "ENABLED"
  enable_token_revocation                       = true
  enable_propagate_additional_user_context_data = false
  auth_session_validity                         = 3

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_domain" "auth" {
  domain                = "${var.project_prefix}-auth"
  user_pool_id          = aws_cognito_user_pool.main.id
  managed_login_version = 2
}

resource "aws_cognito_user_group" "admins" {
  name         = "Admins"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "System operators and verifiers"
  precedence   = 1
}

resource "aws_cognito_user_group" "finance_admins" {
  name         = "FinanceAdmins"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Quản trị tài chính: duyệt STK, lệnh rút, đối soát (TL-05)"
  precedence   = 1
}

resource "aws_cognito_user_group" "partners" {
  name         = "Partners"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Verified recycling and repair shops"
  precedence   = 2
}

resource "aws_cognito_user_group" "owners" {
  name         = "Owners"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Device sellers"
  precedence   = 3
}

resource "aws_lambda_permission" "cognito_pre_signup" {
  statement_id  = "CSI_PreSignUp_ap-southeast-12s8lHgpGI_CSI_PreSignUp"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.main.arn
}

resource "aws_lambda_permission" "cognito_post_confirmation" {
  statement_id  = "CSI_PostConfirmation_ap-southeast-12s8lHgpGI_CSI_PostConfirmation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_confirmation.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.main.arn
}
