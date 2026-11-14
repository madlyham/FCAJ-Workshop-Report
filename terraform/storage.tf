resource "aws_dynamodb_table" "core" {
  name                        = "${var.project_prefix}-core-table"
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "PK"
  range_key                   = "SK"
  deletion_protection_enabled = false
  tags                        = var.common_tags

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  attribute {
    name = "GSI1PK"
    type = "S"
  }

  attribute {
    name = "GSI1SK"
    type = "S"
  }

  global_secondary_index {
    name            = "GSI1"
    hash_key        = "GSI1PK"
    range_key       = "GSI1SK"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  point_in_time_recovery {
    enabled                 = true
    recovery_period_in_days = 35
  }
}

resource "aws_s3_bucket" "images" {
  bucket = "${var.project_prefix}-images-${var.bucket_suffix}"
  tags   = var.common_tags
}

resource "aws_s3_bucket_public_access_block" "images" {
  bucket                  = aws_s3_bucket.images.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_cors_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = [
      "http://localhost:5173",
      "https://${aws_cloudfront_distribution.web.domain_name}",
    ]
    expose_headers = ["ETag"]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "images" {
  bucket                                 = aws_s3_bucket.images.id
  transition_default_minimum_object_size = "all_storage_classes_128K"

  rule {
    id     = "${var.project_prefix}-listing-images-unattached"
    status = "Enabled"

    filter {
      and {
        prefix                   = "listings/"
        object_size_greater_than = 0
        tags = {
          state = "pending"
        }
      }
    }

    expiration {
      days = 1
    }
  }

  rule {
    id     = "${var.project_prefix}-listing-images-retention"
    status = "Enabled"

    filter {
      prefix = "listings/"
    }

    expiration {
      days = 90
    }
  }

  rule {
    id     = "${var.project_prefix}-abort-incomplete-uploads"
    status = "Enabled"

    filter {
      prefix = "listings/"
    }

    expiration {
      expired_object_delete_marker = false
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

resource "aws_s3_bucket" "web" {
  bucket = "${var.project_prefix}-web-${var.bucket_suffix}"
  tags   = var.common_tags
}

resource "aws_s3_bucket_public_access_block" "web" {
  bucket                  = aws_s3_bucket.web.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "web" {
  bucket = aws_s3_bucket.web.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.web.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudFrontRead"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.web.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.web.arn
          }
        }
      },
      {
        Sid    = "CloudFrontList"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.web.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.web.arn
          }
        }
      }
    ]
  })
}
