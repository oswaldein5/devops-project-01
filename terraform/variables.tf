#* Definition of variables in the global context
variable "virginia_cidr" {
  description = "Network segment to use in the VPC of the Virginia region (us-east-1)"
  type        = string
}

variable "vpc_availability_zones" {
  description = "Availability zones to use in the Virginia region (us-east-1)"
  type        = list(string)
}

variable "min_instances" {
  description = "The minimum number of instances (Apache-PHP) to create with Auto Scaling Group (ASG)"
  type        = number
}

variable "max_instances" {
  description = "The maximum number of instances (Apache-PHP) to create with Auto Scaling Group (ASG)"
  type        = number
}

variable "ec2_specs" {
  type = list(object({
    ami           = string
    instance_type = string
  }))
}

variable "git_repo_url" {
  description = "URL of the Git repo with the source code and other project files"
  type        = string
}

variable "git_branch" {
  description = "Branch of the Git repo to use on the EC2 instances"
  type        = string
}

variable "domain_name" {
  description = "Domain to use for name resolution (DNS)"
  type        = string
}

variable "tags" {
  description = "Project tags"
  type        = map(string)
}
