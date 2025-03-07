#* Definición de variables

variable "virginia_cidr" {}          # Segmento de red a usar en el VPC de la región Virginia (us-east-1)
variable "vpc_availability_zones" {} # Zonas de disponibilidad a usar en la región Virginia (us-east-1)
variable "sufix" {}                  # Etiquetas del proyecto agregadas al Name tags de cada recurso
