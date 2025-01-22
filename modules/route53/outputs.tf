output "domain_zone_id" {
	value = aws_route53_zone.base_domain_zone.zone_id
}

output "certificate_arn" {
	value = aws_acm_certificate.certificate_domain.arn
}

output "domain_validation_options" {
	value = aws_acm_certificate.certificate_domain.domain_validation_options
}