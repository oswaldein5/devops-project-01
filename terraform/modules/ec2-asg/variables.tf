#* Variable definitions

variable "min_instances" {}            # The minimum number of instances (Apache-PHP) to create with Auto Scaling Group (ASG)
variable "max_instances" {}            # The maximum number of instances (Apache-PHP) to create with Auto Scaling Group (ASG)
variable "ec2_specs" {}                # EC2 instance specifications
variable "git_repo_url" {}             # Git repository URL
variable "git_branch" {}               # Git repository branch
variable "private_subnet_ids" {}       # ID assigned to the private IP of each instance (Apache-PHP and MySQL)
variable "public_subnet_bastion_id" {} # ID assigned to the public IP of the Bastion instance
variable "internet_gateway_id" {}      # ID assigned to the Internet Gateway
variable "sg_srv_web_id" {}            # Security group ID assigned to the LAMP instances
variable "sg_srv_mysql_id" {}          # Security group ID assigned to the MySQL instance
variable "sg_bastion_id" {}            # Security group ID assigned to the Bastion instance
variable "alb_target_group_arn" {}     # ARN of the ALB target group
variable "sufix" {}                    # Project tags added to the Name tags of each resource
