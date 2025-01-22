
# Criando um bucket S3 para armazenar os arquivos
resource "aws_s3_bucket" "cdn_conversales_landing_page" {
  bucket = "cdn-landing-page-${var.project_name}"

  tags = {
    Name = "Bucket para CloudFront"
  }
}


resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.cdn_conversales_landing_page.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "cdn_build" {
  bucket = "cdn-build-${var.project_name}"

  tags = {
    Name = "Bucket para arquivos de build"
  }
}


resource "aws_s3_bucket_public_access_block" "bucket_public_access_cdn_build" {
  bucket = aws_s3_bucket.cdn_build.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_cloudfront_origin_access_control" "cloudfront_acl" {
  name = "ACL - ${var.project_name}-front-bucket"

  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "redirect_cloudfront" {
  name    = "redirect-cloudfront"
  runtime = "cloudfront-js-1.0"

  code = <<EOF
  function handler(event) {
      var request = event.request;
      var uri = request.uri;

      // Example logic for redirecting requests
      if (uri.endsWith("/")) {
          request.uri += "index.html";
      }
      return request;
  }
  EOF
}


# Criando o CloudFront Distribution
resource "aws_cloudfront_distribution" "landing_page_cdn" {
  origin {
    origin_id                = var.domain
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_acl.id
    domain_name = aws_s3_bucket.cdn_conversales_landing_page.bucket_regional_domain_name
  }


  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain] # Change to your domain

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.domain

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }



    function_association {
      event_type   = "viewer-request"
      function_arn  = "${aws_cloudfront_function.redirect_cloudfront.arn}"
    }

    # viewer_protocol_policy = "allow-all"
    viewer_protocol_policy = "redirect-to-https"
  }
    custom_error_response {
      error_code         = 403
      response_page_path = "/index.html"
      response_code      = 200
    }

    custom_error_response {
      error_code         = 404
      response_page_path = "/index.html"
      response_code      = 200
    }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate.web_app_acm.arn
    ssl_support_method  = "sni-only"
  }
}



resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.cdn_conversales_landing_page.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.cdn_conversales_landing_page.bucket}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.landing_page_cdn.arn
          }
        }
      }
    ]
  })
}


output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.landing_page_cdn.domain_name
}