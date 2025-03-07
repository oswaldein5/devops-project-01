#* Definición de variables

variable "vpc_id" {}        # ID asignado al VPC
variable "virginia_cidr" {} # Segmento de red a usar en el VPC de la región Virginia (us-east-1)
variable "sufix" {}         # Etiquetas del proyecto agregadas al Name tags de cada recurso
