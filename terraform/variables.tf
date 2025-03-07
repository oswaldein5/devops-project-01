#* Definición de variables en el contexto global
variable "virginia_cidr" {
  description = "Segmento de red a usar en el VPC de la región Virginia (us-east-1)"
  type        = string
}

variable "vpc_availability_zones" {
  description = "Zonas de disponibilidad a usar en la región Virginia (us-east-1)"
  type        = list(string)
}

variable "min_instances" {
  description = "El número de instancias min. (Apache-PHP) a crear con Auto Scaling Group (ASG)"
  type        = number
}

variable "max_instances" {
  description = "El número de instancias max. (Apache-PHP) a crear con Auto Scaling Group (ASG)"
  type        = number
}

variable "ec2_specs" {
  type = list(object({
    ami           = string
    instance_type = string
  }))
}

variable "git_repo_url" {
  description = "URL del repo Git con el código fuente y demás archivos del proyecto"
  type        = string
}

variable "git_branch" {
  description = "Rama del repo Git a usar en las instancias EC2"
  type        = string
}

variable "domain_name" {
  description = "Dominio a usar para la resolución de nombres (DNS)"
  type        = string
}

variable "tags" {
  description = "Etiquetas del proyecto"
  type        = map(string)
}
