#* Asignación de valor a las variables en el contexto global
virginia_cidr          = "10.0.0.0/16"                              # Segmento de red a usar en el VPC de la región Virginia (us-east-1)                             # Región a usar en AWS  
vpc_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"] # Zonas de disponibilidad a usar en la región Virginia (us-east-1)
domain_name            = "gowebsite.info"                           # Dominio a usar para la resolución de nombres (DNS)
min_instances          = 2                                          # El número de instancias min. (Apache-PHP) a crear con Auto Scaling Group (ASG)
max_instances          = 3                                          # El número de instancias max. (Apache-PHP) a crear con Auto Scaling Group (ASG)

ec2_specs = [
  {
    "ami"           = "ami-0e2c8caa4b6378d8c" # Ubuntu Server 24.04 LTS
    "instance_type" = "t2.micro"
  },
  {
    "ami"           = "ami-0ca9fb66e076a6e32" # Amazon Linux 2
    "instance_type" = "t2.micro"
  }
] # Especificaciones de las instancias EC2

# URL del repositorio Git
git_repo_url = "https://token@oswaldo.visualstudio.com/repo/_git/repo"

git_branch = "main" # Rama del repositorio Git (Entorno de Producción)

tags = {
  "region"       = "us-east-1"
  "env"          = "PROD"
  "contributors" = "Oswaldo Solano"
  "IAC"          = "Terraform"
  "IAC-v"        = "1.9.8"
  "project"      = "TFM"
} # Etiquetas del proyecto
