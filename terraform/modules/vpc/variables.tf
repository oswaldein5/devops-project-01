#* Variable definitions

variable "virginia_cidr" {}          # Network segment to use in the Virginia region VPC (us-east-1)
variable "vpc_availability_zones" {} # Availability zones to use in the Virginia region (us-east-1)
variable "sufix" {}                  # Project labels added to the Name tags of each resource
