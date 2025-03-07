#* Recurso para crear un certificado SSL con ACM, una zona privada de Route 53 
#* y registros tipo "A" para las instancias EC2 Apache-PHP y MySQL

#* Crear una zona privada de Route 53 para el servidor MySQL
resource "aws_route53_zone" "private_zone" {
  name = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name = "private-zone-${var.sufix}"
  }
}

#* Crear registro tipo "A" en Route 53 para las instancias EC2 Apache-PHP en la zona publica
resource "aws_route53_record" "ec2_srv_web_record" {
  zone_id = data.aws_route53_zone.public_zone.id

  name = var.domain_name
  type = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

#* Crear registro tipo "A" en Route 53 para las instancia EC2 MySQL en la zona privada
resource "aws_route53_record" "ec2_mysql_record" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "srv-bd.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [var.ec2_mysql_private_ip]
}

#* Certificado SSL con ACM
resource "aws_acm_certificate" "cert_acm" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "cert-acm-${var.sufix}"
  }
}

#* Crear los registros DNS necesarios para la validación del certificado
resource "aws_route53_record" "cert_validation_record" {
  zone_id = data.aws_route53_zone.public_zone.id

  for_each = {
    for dvo in aws_acm_certificate.cert_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
}

#* Validar certificado SSL existente con ACM
resource "aws_acm_certificate_validation" "cert_validation" {
  timeouts {
    create = "5m" # Aumentar el tiempo de espera a 5 minutos
  }
  certificate_arn         = aws_acm_certificate.cert_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}
