resource "aws_cloudfront_origin_access_control" "web" {
  name                              = "${var.project_prefix}-web"
  description                       = "ReLoop 2 web bucket OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "spa_rewrite" {
  name    = "${var.project_prefix}-spa-rewrite"
  comment = "SPA: non-asset route -> /index.html"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/functions/spa-rewrite.js")
}

resource "aws_cloudfront_function" "api_prefix" {
  name    = "${var.project_prefix}-api-prefix"
  comment = "Strip /api prefix before forwarding to API Gateway"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/functions/api-prefix.js")
}

resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name    = "${var.project_prefix}-security-headers"
  comment = "ReLoop 2 security headers: CSP, HSTS, X-Frame-Options"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    content_security_policy {
      content_security_policy = "frame-ancestors 'none'; object-src 'none'; base-uri 'self'; form-action 'self'"
      override                = true
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      preload                    = false
      override                   = true
    }
  }

  custom_headers_config {
    items {
      header   = "Content-Security-Policy-Report-Only"
      override = true
      value    = "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: blob: https://${aws_s3_bucket.images.bucket_regional_domain_name} https://images.unsplash.com https://cdn.magicpatterns.com https://*.tile.openstreetmap.org; connect-src 'self' https://cognito-idp.${data.aws_region.current.region}.amazonaws.com https://${aws_cognito_user_pool_domain.auth.domain}.auth.${data.aws_region.current.region}.amazoncognito.com https://nominatim.openstreetmap.org https://${aws_s3_bucket.images.bucket_regional_domain_name}; frame-ancestors 'none'; object-src 'none'; base-uri 'self'; form-action 'self'"
    }
  }
}

resource "aws_cloudfront_distribution" "web" {
  enabled             = true
  is_ipv6_enabled     = false
  http_version        = "http2and3"
  comment             = "${var.project_prefix} web"
  default_root_object = "index.html"
  price_class         = "PriceClass_200"
  web_acl_id          = aws_wafv2_web_acl.web.arn
  tags                = merge(var.common_tags, { Name = "${var.project_prefix}-web" })

  origin {
    domain_name              = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id                = var.web_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.web.id
    connection_attempts      = 3
    connection_timeout       = 10
  }

  origin {
    domain_name         = replace(aws_apigatewayv2_api.http.api_endpoint, "https://", "")
    origin_id           = "api"
    connection_attempts = 3
    connection_timeout  = 10

    custom_header {
      name  = "x-origin-verify"
      value = var.origin_verify_secret
    }

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_read_timeout      = 30
      origin_keepalive_timeout = 5
      ip_address_type          = "ipv4"
    }
  }

  default_cache_behavior {
    target_origin_id           = var.web_origin_id
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.spa_rewrite.arn
    }
  }

  ordered_cache_behavior {
    path_pattern               = "/api/*"
    target_origin_id           = "api"
    viewer_protocol_policy     = "https-only"
    allowed_methods            = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = false
    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.api_prefix.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
