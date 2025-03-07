#* Terraform configuration block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.82.0"
    }
  }
  required_version = ">=1.9.8"
}

#* AWS provider configuration block
provider "aws" {
  # Define alias 
  # alias = "us-east-1"

  # Define region
  region = "us-east-1"

  # Define default tags for the entire project
  default_tags {
    tags = var.tags
  }
}
