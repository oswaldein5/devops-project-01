#!/bin/bash
# === Script: setup-srv-bd.sh ===

# Description:
# This script automates the configuration of a MySQL server in Docker within an AWS instance.

# Main functionalities:
# - Updates and installs necessary packages (Docker, AWS CLI, additional tools).
# - Configures AWS credentials (optional if not using IAM roles).
# - Retrieves MySQL credentials (root and admin) from AWS Secrets Manager.
# - Builds the Docker image for MySQL from a custom Dockerfile.
# - Runs the Docker container with the necessary environment variables.
# - Cleans up temporary and installation files.

# Requirements:
# - Access to AWS Secrets Manager to obtain MySQL credentials.
# - Application files in `/home/ubuntu/EcolacMigracion`.

# Author:    Oswaldo Solano
# Date:      01/Feb/2025
# Version:   1.0

# Variables
MYSQL_DATABASE="dbtest"

# Update packages and install Docker
sudo apt-get update -y
sudo apt-get install -y docker.io curl unzip jq

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add the current user to the Docker group
sudo usermod -aG docker ubuntu
# sudo usermod -aG docker vagrant

# Configure AWS credentials (only if not using IAM roles)
export AWS_ACCESS_KEY_ID="XXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXX"
export AWS_DEFAULT_REGION="us-east-1"

# Retrieve secrets from AWS Secrets Manager
MYSQL_ADMIN_CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id mysql-admin-credentials --query SecretString --output text)
MYSQL_ROOT_CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id mysql-root-credentials --query SecretString --output text)
ADMIN_USERNAME=$(echo "$MYSQL_ADMIN_CREDENTIALS" | jq -r '.username')
ADMIN_PASSWORD=$(echo "$MYSQL_ADMIN_CREDENTIALS" | jq -r '.password')
MYSQL_ROOT_PASSWORD=$(echo "$MYSQL_ROOT_CREDENTIALS" | jq -r '.password')

# Go to the application directory
cd /home/ubuntu/repo || exit
# cd /home/vagrant/srv-bd || exit

# Build the Docker image for MySQL
# docker build -t srv-mysql -f srv-bd/Dockerfile .
docker build -t srv-mysql .

# Run the Docker container for MySQL with the environment variables
docker run -d -p 3306:3306 --name mysql-ct \
  --restart unless-stopped \
  -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  -e MYSQL_USER="$ADMIN_USERNAME" \
  -e MYSQL_PASSWORD="$ADMIN_PASSWORD" \
  srv-mysql

# Clean up installation and temporary files
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /home/ubuntu/repo/*.zip
sudo rm -rf /home/ubuntu/repo/aws