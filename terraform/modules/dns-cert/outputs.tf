# Definition of Outputs

# ARN of the SSL certificate generated with ACM
output "certificate_ssl_acm_arn" {
  value = aws_acm_certificate.cert_acm.arn
}
