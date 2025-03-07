#* Definición de variables

variable "vpc_id" {}               # ID asignado al VPC
variable "ec2_mysql_private_ip" {} # IP privada asignada a la instancia MySQL
variable "alb_dns_name" {}         # Nombre DNS asignado al ALB
variable "alb_zone_id" {}          # ID de la zona del ALB
variable "domain_name" {}          # Dominio a usar para la resolución de nombres (DNS)
variable "sufix" {}                # Etiquetas del proyecto agregadas al Name tags de cada recurso
