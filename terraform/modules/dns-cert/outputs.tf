#* Definición de Outputs

#* ARN del certificado SSL generado con ACM
output "certificate_ssl_acm_arn" {
  value = aws_acm_certificate.cert_acm.arn
}
