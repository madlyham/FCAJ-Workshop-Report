output "cloudfront_domain" {
  value = aws_cloudfront_distribution.web.domain_name
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.http.api_endpoint
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.web.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.core.name
}

output "images_bucket_name" {
  value = aws_s3_bucket.images.bucket
}

output "web_bucket_name" {
  value = aws_s3_bucket.web.bucket
}

output "guardrail_id" {
  value = aws_bedrock_guardrail.main.guardrail_id
}
