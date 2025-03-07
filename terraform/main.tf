#****************************************************************************
#* Project:         Provisioning resources in AWS with Terraform
#* Description:     Create resources using Terraform to provision:
#*                    - Apache-PHP Server / EC2 Instances (2-3)
#*                    - MySQL / EC2 Instance (1)
#*                    - Bastion / EC2 Instance (1)
#*                    - Auto Scaling Group (ASG)
#*                    - Application Load Balancer (ALB)
#*                    - DNS (Route 53)
#*                    - SSL Certificate (ACM)
#* Author:          Oswaldo Solano
#* Date:            18/Dec/2024
#* Environment:     Production (main)
#* Cloud Provider:  Amazon Web Services (AWS)
#****************************************************************************

#* Module to create all necessary resources for the Virtual Private Cloud (VPC)
module "vpc" {
  source                 = "./modules/vpc"
  virginia_cidr          = var.virginia_cidr
  vpc_availability_zones = var.vpc_availability_zones
  sufix                  = local.sufix
}

#* Module to create all necessary resources for the Security Groups
module "security_groups" {
  source        = "./modules/sgs"
  virginia_cidr = var.virginia_cidr
  vpc_id        = module.vpc.vpc_id # output from module: vpc
  sufix         = local.sufix
}

#* Module to create EC2 Instances (Apache-PHP) with Auto Scaling Group (ASG) and EC2 Instances (MySQL and Bastion)
module "ec2_asg" {
  source                   = "./modules/ec2-asg"
  min_instances            = var.min_instances
  max_instances            = var.max_instances
  ec2_specs                = var.ec2_specs
  git_repo_url             = var.git_repo_url
  git_branch               = var.git_branch
  private_subnet_ids       = module.vpc.private_subnet_ids                 # output from module: vpc
  public_subnet_bastion_id = module.vpc.public_subnet_ids[2]               # output from module: vpc
  internet_gateway_id      = module.vpc.internet_gateway_id                # output from module: vpc
  sg_srv_web_id            = module.security_groups.sg_srv_web_id          # output from module: security_groups
  sg_srv_mysql_id          = module.security_groups.sg_srv_mysql_id        # output from module: security_groups
  sg_bastion_id            = module.security_groups.sg_bastion_id          # output from module: security_groups
  alb_target_group_arn     = module.app_load_balancer.alb_target_group_arn # output from module: app_load_balancer
  sufix                    = local.sufix
}

#* Module to create all necessary resources for the Application Load Balancer (ALB)
module "app_load_balancer" {
  source                  = "./modules/alb"
  vpc_id                  = module.vpc.vpc_id                       # output from module: vpc
  public_subnet_ids       = module.vpc.public_subnet_ids            # output from module: vpc
  sg_alb_id               = module.security_groups.sg_alb_id        # output from module: security_groups
  certificate_ssl_acm_arn = module.dns_cert.certificate_ssl_acm_arn # output from module: dns_cert
  sufix                   = local.sufix
}

#* Module to create all necessary resources for DNS resolution (Route 53) and SSL certificates
module "dns_cert" {
  source               = "./modules/dns-cert"
  vpc_id               = module.vpc.vpc_id                     # output from module: vpc
  ec2_mysql_private_ip = module.ec2_asg.ec2_mysql_private_ip   # output from module: ec2_asg
  alb_dns_name         = module.app_load_balancer.alb_dns_name # output from module: app_load_balancer
  alb_zone_id          = module.app_load_balancer.alb_zone_id  # output from module: app_load_balancer
  domain_name          = var.domain_name
  sufix                = local.sufix
}