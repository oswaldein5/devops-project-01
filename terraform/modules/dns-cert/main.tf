# Resource to create an SSL certificate with ACM, a private Route 53 zone, 
# and "A" records for Apache-PHP and MySQL EC2 instances

# Create a private Route 53 zone for the MySQL server
resource "aws_route53_zone" "private_zone" {
  name = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name = "private-zone-${var.sufix}"
  }
}

# Create an "A" record in Route 53 for the Apache-PHP EC2 instances in the public zone
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

# Create an "A" record in Route 53 for the MySQL EC2 instance in the private zone
resource "aws_route53_record" "ec2_mysql_record" {
  zone_id = aws_route53_zone.private_zone.id
  name    = "srv-bd.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [var.ec2_mysql_private_ip]
}

# SSL certificate with ACM
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

# Create the necessary DNS records for certificate validation
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

# Validate existing SSL certificate with ACM
resource "aws_acm_certificate_validation" "cert_validation" {
  timeouts {
    create = "5m" # Increase the timeout to 5 minutes
  }
  certificate_arn         = aws_acm_certificate.cert_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}
