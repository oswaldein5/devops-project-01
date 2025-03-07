#* Definición de variables

variable "vpc_id" {}                  # ID asignado al VPC
variable "sg_alb_id" {}               # ID del grupo de seguridad asignado para el ALB
variable "public_subnet_ids" {}       # ID asignado a cada IP pública
variable "certificate_ssl_acm_arn" {} # ARN del certificado SSL
variable "sufix" {}                   # Etiquetas del proyecto agregadas al Name tags de cada recurso
