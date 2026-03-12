# this data source to get access to the effective Account ID, User ID, and ARN in which Terraform is authorized.
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "site" {
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
}


# resource "aws_s3_bucket_ownership_controls" "site" {
#   bucket = aws_s3_bucket.site.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.project_name}-oac"
  description                       = "Origin access control for ${var.project_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}



resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
    origin_id                = aws_s3_bucket.site.id
  }

  enabled             = true
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.site.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }


  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["CA", "GB"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = templatefile("${path.module}/policies/cloudfront.json", {
    bucket_arn              = aws_s3_bucket.site.arn
    cloudfront_distribution = aws_cloudfront_distribution.s3_distribution.arn
  })
}

resource "aws_s3_object" "site_files" {
  for_each = { for file in local.site_files : file => file if !endswith(file, "/") }

  bucket       = aws_s3_bucket.site.id
  key          = each.key
  source       = "${var.site_path}/${each.key}"
  etag         = filemd5("${var.site_path}/${each.key}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), "application/octet-stream")

}
