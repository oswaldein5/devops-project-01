# Assigning values to variables in the global context
virginia_cidr          = "10.0.0.0/16"                              # Network segment to use in the Virginia region (us-east-1)
vpc_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"] # Availability zones to use in the Virginia region (us-east-1)
domain_name            = "gowebsite.info"                           # Domain to use for DNS resolution
min_instances          = 2                                          # Minimum number of instances (Apache-PHP) to create with Auto Scaling Group (ASG)
max_instances          = 3                                          # Maximum number of instances (Apache-PHP) to create with Auto Scaling Group (ASG)

ec2_specs = [
  {
    "ami"           = "ami-0e2c8caa4b6378d8c" # Ubuntu Server 24.04 LTS
    "instance_type" = "t2.micro"
  },
  {
    "ami"           = "ami-0ca9fb66e076a6e32" # Amazon Linux 2
    "instance_type" = "t2.micro"
  }
] # EC2 instance specifications

# Git repository URL
git_repo_url = "https://token@user/project/_git/repo"

git_branch = "main" # Git repository branch (Production environment)

tags = {
  "region"       = "us-east-1"
  "env"          = "PROD"
  "contributors" = "Oswaldo Solano"
  "IAC"          = "Terraform"
  "IAC-v"        = "1.9.8"
  "project"      = "TFM"
} # Project tags
