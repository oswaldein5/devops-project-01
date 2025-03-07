#* Definition of Data Sources

#* Read the existing public zone in AWS Route 53
data "aws_route53_zone" "public_zone" {
  name         = var.domain_name
  private_zone = false
}
