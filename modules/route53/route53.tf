# resource "aws_route53_zone" "base_domain_zone" {
# 	name = var.base_domain
# }

# # resource "aws_route53_record" "serverless_redirect" {
# # 	type = "CNAME"
# # 	name = var.bot_api
# # 	records = ["${var.serverless_domain}"]
# # 	zone_id = aws_route53_zone.base_domain_zone.zone_id
# # 	ttl = 300
# # }

# resource "aws_acm_certificate" "certificate_domain" {
#   domain_name       = var.base_domain
#   subject_alternative_names = [var.landing_page_domain_ptbr]
#   validation_method = "DNS"
# }

# resource "aws_route53_record" "acm_validation_website" {
#   for_each = {
#     for dvo in aws_acm_certificate.certificate_domain.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 300
#   type            = each.value.type
#   zone_id         = aws_route53_zone.base_domain_zone.zone_id
# }