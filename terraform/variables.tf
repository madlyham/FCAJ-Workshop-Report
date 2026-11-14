variable "aws_region" {
  description = "Primary AWS region for ReLoop backend and S3 assets"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_prefix" {
  description = "Resource name prefix (e.g., reloop2 or reloop)"
  type        = string
  default     = "reloop2"
}

variable "bucket_suffix" {
  description = "Short unique suffix appended to S3 bucket names"
  type        = string
  default     = "7k3q"
}

variable "alert_email" {
  description = "Email address subscribed to AWS Budgets and SNS alarm notifications"
  type        = string
  sensitive   = true
}

variable "origin_verify_secret" {
  description = "Shared secret sent by CloudFront in x-origin-verify header to Lambda"
  type        = string
  sensitive   = true
}

variable "ai_model_id" {
  description = "Bedrock model or inference profile ID used for device image analysis"
  type        = string
  default     = "global.moonshotai.kimi-k3"
}

variable "budget_limit_usd" {
  description = "Monthly AWS cost budget ceiling in USD"
  type        = string
  default     = "5.0"
}

variable "budget_time_period_start" {
  description = "Monthly budget period start in UTC (YYYY-MM-DD_HH:MM)"
  type        = string
  default     = "2026-11-01_00:00"
}

variable "api_zip_path" {
  description = "Path to built backend API Lambda deployment archive"
  type        = string
  default     = "./zips/reloop2-api.zip"
}

variable "post_confirmation_zip_path" {
  description = "Path to Cognito PostConfirmation Lambda deployment archive"
  type        = string
  default     = "./zips/reloop2-post-confirmation.zip"
}

variable "role_permissions_boundary_name" {
  description = "Optional IAM managed policy name used as permissions boundary for Lambda roles"
  type        = string
  default     = "TeamAppRoleBoundary"
}

variable "billing_bank_name" {
  description = "Optional platform bank name for payout reconciliation env vars"
  type        = string
  default     = ""
}

variable "billing_account_no" {
  description = "Optional platform bank account number for payout reconciliation env vars"
  type        = string
  default     = ""
}

variable "billing_account_name" {
  description = "Optional platform bank account holder name for payout reconciliation env vars"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Standard resource tags applied to identity and compute resources"
  type        = map(string)
  default = {
    Owner   = "team"
    Project = "reloop2"
    Purpose = "workshop"
  }
}

variable "cloudfront_cors_origins" {
  description = "CloudFront HTTPS origins added to HTTP API CORS after distribution creation (avoids TF cycle with API origin)"
  type        = list(string)
  default     = []
}

variable "web_origin_id" {
  description = "Origin ID used by CloudFront distribution for the S3 web origin"
  type        = string
  default     = "s3-web"
}
