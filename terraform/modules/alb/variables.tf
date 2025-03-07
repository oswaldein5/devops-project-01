#* Variable definitions

variable "vpc_id" {}                  # ID assigned to the VPC
variable "sg_alb_id" {}               # ID of the security group assigned to the ALB
variable "public_subnet_ids" {}       # ID assigned to each public subnet
variable "certificate_ssl_acm_arn" {} # ARN of the SSL certificate
variable "sufix" {}                   # Project tags added to the Name tags of each resource
