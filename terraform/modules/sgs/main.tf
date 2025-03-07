#* Módulo para crear todos los recursos necesarios para los Grupos de Seguridad (Security Groups)

#* Recurso para crear un grupo de seguridad para el Application Load Balancer (ALB)
resource "aws_security_group" "sg_alb" {
  name        = "sg_alb"
  vpc_id      = var.vpc_id
  description = "Grupo de seguridad para el Application Load Balancer (ALB)"

  tags = {
    Name = "sg-alb-${var.sufix}"
  }
}

#* Regla de entrada para permitir el tráfico entrante desde Internet al puerto 80 en el ALB
resource "aws_security_group_rule" "ingress_alb_traffic_http" {
  security_group_id = aws_security_group.sg_alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Ingress HTTP"
}

#* Regla de entrada para permitir el tráfico entrante desde Internet al puerto 443 en el ALB
resource "aws_security_group_rule" "ingress_alb_traffic_https" {
  security_group_id = aws_security_group.sg_alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Ingress HTTPS"
}

#* Regla de salida para permitir el tráfico HTTP a la instancia Apache-PHP
resource "aws_security_group_rule" "egress_alb_traffic_http" {
  security_group_id        = aws_security_group.sg_alb.id
  source_security_group_id = aws_security_group.sg_srv_web.id
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Egress HTTP"
}

#* Regla de salida para permitir el tráfico HTTPS a la instancia Apache-PHP
resource "aws_security_group_rule" "egress_alb_traffic_https" {
  security_group_id        = aws_security_group.sg_alb.id
  source_security_group_id = aws_security_group.sg_srv_web.id
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Egress HTTPS"
}

#* Recurso para crear un grupo de seguridad para la instancia EC2 (Apache-PHP)
resource "aws_security_group" "sg_srv_web" {
  name        = "sg_srv_web"
  vpc_id      = var.vpc_id
  description = "Grupo de seguridad para instancia EC2 (Apache-PHP)"

  tags = {
    Name = "sg-srv-web-${var.sufix}"
  }
}

#* Regla de entrada para permitir el tráfico ICMP desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_web_ingress_icmp" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress ICMP"
}

#* Regla de entrada para permitir el tráfico SSH entrante desde la instancia Bastion
resource "aws_security_group_rule" "sgr_srv_web_ingress_ssh" {
  security_group_id        = aws_security_group.sg_srv_web.id
  source_security_group_id = aws_security_group.sg_bastion.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "Ingress SSH"
}

#* Regla de entrada para permitir el tráfico HTTP entrante desde el ALB
resource "aws_security_group_rule" "sgr_srv_web_ingress_http" {
  security_group_id        = aws_security_group.sg_srv_web.id
  source_security_group_id = aws_security_group.sg_alb.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Ingress HTTP desde ALB"
}

#* Regla de entrada para permitir el tráfico HTTPS entrante desde el ALB
resource "aws_security_group_rule" "sgr_srv_web_ingress_https" {
  security_group_id        = aws_security_group.sg_srv_web.id
  source_security_group_id = aws_security_group.sg_alb.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Ingress HTTPS desde ALB"
}

#* Regla de salida para permitir tráfico HTTP a Internet desde sg_srv_web
resource "aws_security_group_rule" "sgr_srv_web_egress_http" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTP"
}

#* Regla de salida para permitir tráfico HTTPS a Internet desde sg_srv_web
resource "aws_security_group_rule" "sgr_srv_web_egress_https" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTPS"
}

#* Regla de salida para permitir el tráfico ICMP desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_web_egress_icmp" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}

#* Regla de salida para permitir el tráfico tcp/3306 desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_web_egress_db" {
  security_group_id = aws_security_group.sg_srv_web.id
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress tcp/3306"
}

#* Recurso para crear un grupo de seguridad para la instancia EC2 (MySQL)
resource "aws_security_group" "sg_srv_mysql" {
  name        = "sg_srv_mysql"
  vpc_id      = var.vpc_id
  description = "Grupo de seguridad para instancia EC2 (MySQL)"

  tags = {
    Name = "sg-srv-mysql-${var.sufix}"
  }
}

#* Regla de entrada para permitir el tráfico ICMP desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_mysql_ingress_icmp" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress ICMP"
}

#* Regla de entrada para permitir el tráfico SSH entrante desde la instancia Bastion
resource "aws_security_group_rule" "sgr_srv_mysql_ingress_ssh" {
  security_group_id        = aws_security_group.sg_srv_mysql.id
  source_security_group_id = aws_security_group.sg_bastion.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "Ingress SSH"
}

#* Regla de entrada para permitir el tráfico tcp/3306 desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_mysql_ingress_db" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Ingress tcp/3306"
}

#* Regla de salida para permitir tráfico HTTP a Internet desde sg_srv_mysql
resource "aws_security_group_rule" "sgr_srv_mysql_egress_http" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTP"
}

#* Regla de salida para permitir tráfico HTTPS a Internet desde sg_srv_mysql
resource "aws_security_group_rule" "sgr_srv_mysql_egress_https" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress HTTPS"
}

#* Regla de salida para permitir el tráfico ICMP desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_srv_mysql_egress_icmp" {
  security_group_id = aws_security_group.sg_srv_mysql.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}

#* Recurso para crear un grupo de seguridad para la instancia EC2 (Bastion)
resource "aws_security_group" "sg_bastion" {
  name        = "sg_bastion"
  vpc_id      = var.vpc_id
  description = "Grupo de seguridad para instancia EC2 (Bastion)"

  tags = {
    Name = "sg-bastion-${var.sufix}"
  }
}

#* Regla de entrada para permitir el tráfico SSH desde una IP pública
resource "aws_security_group_rule" "sgr_bastion_ingress_ssh" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # IP pública de los Administradores
  description       = "Ingress SSH"
}

#* Regla de salida para permitir el tráfico SSH desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_bastion_egress_ssh" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress SSH"
}

#* Regla de salida para permitir el tráfico ICMP desde la VPC (10.0.0.0/16)
resource "aws_security_group_rule" "sgr_bastion_egress_icmp" {
  security_group_id = aws_security_group.sg_bastion.id
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [var.virginia_cidr]
  description       = "Egress ICMP"
}
