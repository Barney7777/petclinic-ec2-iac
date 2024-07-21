output "acm_certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

output "hosted_zone_name" {
  value = var.hosted_zone_name
}