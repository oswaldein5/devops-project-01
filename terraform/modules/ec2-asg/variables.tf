#* Definición de variables

variable "min_instances" {}            # El número de instancias min. (Apache-PHP) a crear con Auto Scaling Group (ASG)
variable "max_instances" {}            # El número de instancias max. (Apache-PHP) a crear con Auto Scaling Group (ASG)
variable "ec2_specs" {}                # Especificaciones de la instancia EC2
variable "git_repo_url" {}             # URL del repositorio Git
variable "git_branch" {}               # Rama del repositorio Git
variable "private_subnet_ids" {}       # ID asignado a la IP privada de cada instancia (Apache-PHP y MySQL)
variable "public_subnet_bastion_id" {} # Id asignado a la IP pública de la instancia Bastion
variable "internet_gateway_id" {}      # ID asignado al Internet Gateway
variable "sg_srv_web_id" {}            # ID del grupo de seguridad asignado para las instancias LAMP
variable "sg_srv_mysql_id" {}          # ID del grupo de seguridad asignado para la instancia MySQL
variable "sg_bastion_id" {}            # ID del grupo de seguridad asignado para la instancia Bastion
variable "alb_target_group_arn" {}     # ARN del target group del ALB
variable "sufix" {}                    # Etiquetas del proyecto agregadas al Name tags de cada recurso
