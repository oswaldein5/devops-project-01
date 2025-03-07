#* Variable definitions

variable "vpc_id" {}               # ID assigned to the VPC
variable "ec2_mysql_private_ip" {} # Private IP assigned to the MySQL instance
variable "alb_dns_name" {}         # DNS name assigned to the ALB
variable "alb_zone_id" {}          # Zone ID of the ALB
variable "domain_name" {}          # Domain to use for DNS resolution
variable "sufix" {}                # Project tags added to the Name tags of each resource
