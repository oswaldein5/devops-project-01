#* Definicion de Data Sources

#* Leer la zona publica existente en AWS Route 53
data "aws_route53_zone" "public_zone" {
  name         = var.domain_name
  private_zone = false
}
