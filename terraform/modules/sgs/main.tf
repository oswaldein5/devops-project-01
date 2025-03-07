# Module to create all necessary resources for Security Groups

# Resource to create a security group for the Application Load Balancer (ALB)
resource "aws_security_group" "sg_alb" {
  name        = "sg_alb"
  vpc_id      = var.vpc_id
  description = "Security group for the Application Load Balancer (ALB)"

  tags = {
    Name = "sg-alb-${var.sufix}"
  }
}

# Ingress rule to allow incoming traffic from the Internet to port 80 on the ALB
resource "aws_security_group_rule" "ingress_alb_traffic_http" {
  security_group_id = aws_security_group.sg_alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Ingress HTTP"
}

# Ingress rule to allow incoming traffic from the Internet to port 443 on the ALB
resource "aws_security_group_rule" "ingress_alb_traffic_https" {
  security_group_id = aws_security_group.sg_alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Ingress HTTPS"
}

# Egress rule to allow HTTP traffic to the Apache-PHP instance
resource "aws_security_group_rule" "egress_alb_traffic_http" {
  security_group_id        = aws_security_group.sg_alb.id
  source_security_group_id = aws_security_group.sg_srv_web.id
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Egress HTTP"
}

# Egress rule to allow HTTPS traffic to the Apache-PHP instance
resource "aws_security_group_rule" "egress_alb_traffic_https" {
  security_group_id        = aws_security_group.sg_alb.id
  source_security_group_id = aws_security_group.sg_srv_web.id
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Egress HTTPS"
}

# Resource to create a security group for the EC2 instance (Apache-PHP)
resource "aws_security_group" "sg_srv_web" {
  name        = "sg_srv_web"
  vpc_id      = var.vpc_id
  description = "Security group for EC2 instance (Apache-PHP)"

  tags = {
    Name = "sg-srv-web-${var.sufix}"
  }
}

# Ingress rule to allow ICMP traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_web_ingress_icmp" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress ICMP"
}

# Ingress rule to allow SSH traffic from the Bastion instance
resource "aws_security_group_rule" "sgr_srv_web_ingress_ssh" {
  security_group_id        = aws_security_group.sg_srv_web.id
  source_security_group_id = aws_security_group.sg_bastion.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "Ingress SSH"
}

# Ingress rule to allow HTTP traffic from the ALB
resource "aws_security_group_rule" "sgr_srv_web_ingress_http" {
  security_group_id        = aws_security_group.sg_srv_web.id
  source_security_group_id = aws_security_group.sg_alb.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Ingress HTTP from ALB"
}

# Ingress rule to allow HTTPS traffic from the ALB
resource "aws_security_group_rule" "sgr_srv_web_ingress_https" {
  security_group_id        = aws_security_group.sg_srv_web.id
  source_security_group_id = aws_security_group.sg_alb.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Ingress HTTPS from ALB"
}

# Egress rule to allow HTTP traffic to the Internet from sg_srv_web
resource "aws_security_group_rule" "sgr_srv_web_egress_http" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTP"
}

# Egress rule to allow HTTPS traffic to the Internet from sg_srv_web
resource "aws_security_group_rule" "sgr_srv_web_egress_https" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTPS"
}

# Egress rule to allow ICMP traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_web_egress_icmp" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}

# Egress rule to allow tcp/3306 traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_web_egress_db" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress tcp/3306"
}

# Resource to create a security group for the EC2 instance (MySQL)
resource "aws_security_group" "sg_srv_mysql" {
  name        = "sg_srv_mysql"
  vpc_id      = var.vpc_id
  description = "Security group for EC2 instance (MySQL)"

  tags = {
    Name = "sg-srv-mysql-${var.sufix}"
  }
}

# Ingress rule to allow ICMP traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_mysql_ingress_icmp" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress ICMP"
}

# Ingress rule to allow SSH traffic from the Bastion instance
resource "aws_security_group_rule" "sgr_srv_mysql_ingress_ssh" {
  security_group_id        = aws_security_group.sg_srv_mysql.id
  source_security_group_id = aws_security_group.sg_bastion.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "Ingress SSH"
}

# Ingress rule to allow tcp/3306 traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_mysql_ingress_db" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress tcp/3306"
}

# Egress rule to allow HTTP traffic to the Internet from sg_srv_mysql
resource "aws_security_group_rule" "sgr_srv_mysql_egress_http" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTP"
}

# Egress rule to allow HTTPS traffic to the Internet from sg_srv_mysql
resource "aws_security_group_rule" "sgr_srv_mysql_egress_https" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTPS"
}

# Egress rule to allow ICMP traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_mysql_egress_icmp" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}

# Resource to create a security group for the EC2 instance (Bastion)
resource "aws_security_group" "sg_bastion" {
  name        = "sg_bastion"
  vpc_id      = var.vpc_id
  description = "Security group for EC2 instance (Bastion)"

  tags = {
    Name = "sg-bastion-${var.sufix}"
  }
}

# Ingress rule to allow SSH traffic from a public IP
resource "aws_security_group_rule" "sgr_bastion_ingress_ssh" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Public IP of Administrators
  description       = "Ingress SSH"
}

# Egress rule to allow SSH traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_bastion_egress_ssh" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress SSH"
}

# Egress rule to allow ICMP traffic from the VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_bastion_egress_icmp" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}
