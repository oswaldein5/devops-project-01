#* Bloque de configuración de Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.82.0"
    }
  }
  required_version = ">=1.9.8"
}

#* Bloque de configuración del proveedor AWS
provider "aws" {
  # Se define alias 
  # alias = "us-east-1"

  # Se define región
  region = "us-east-1"

  # Se definen las default tags para todo el proyecto
  default_tags {
    tags = var.tags
  }
}
