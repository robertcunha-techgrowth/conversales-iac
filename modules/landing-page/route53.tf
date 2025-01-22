
provider "aws" {
  alias  = "useast"
  region = "us-east-1"
}

resource "aws_route53_zone" "base_domain_zone" {
	name = var.base_domain
}

resource "aws_acm_certificate" "web_app_acm" {
  provider = aws.useast
  domain_name       = var.domain
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert_validation_base_domain" {
  provider = aws.useast
  certificate_arn         = aws_acm_certificate.web_app_acm.arn
  validation_record_fqdns = [for record in aws_acm_certificate.web_app_acm.domain_validation_options : record.resource_record_name]
}

resource "aws_route53_record" "acm_validation_web_application_client" {
  for_each = {
    for dvo in aws_acm_certificate.web_app_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = aws_route53_zone.base_domain_zone.zone_id
}

resource "aws_route53_record" "web_app" {
  depends_on = [aws_cloudfront_distribution.landing_page_cdn]
  zone_id    = aws_route53_zone.base_domain_zone.zone_id
  name       = var.domain # Nome do domínio (pode ser vazio para o apex do domínio)
  type       = "A"

  alias {
    name                   = aws_cloudfront_distribution.landing_page_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.landing_page_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}


# resource "aws_acm_certificate_validation" "cert_validation_web_application_client" {
#   certificate_arn         = var.certificate_arn
#   validation_record_fqdns = [for record in aws_route53_record.acm_validation_web_application_client : record.fqdn]
# }