#!/bin/bash
# === Script: setup-srv-web.sh ===

# Description:
# This script automates the environment setup for deploying a PHP application 
# using Docker on an AWS instance.

# Main functionalities:
# - Updates and installs necessary packages (Docker, AWS CLI, additional tools).
# - Configures AWS credentials (optional if IAM roles are not used).
# - Retrieves MySQL credentials from AWS Secrets Manager.
# - Builds the Docker image from a custom Dockerfile.
# - Runs the Docker container with the necessary environment variables.
# - Cleans up temporary and installation files.

# Requirements:
# - Access to AWS Secrets Manager to obtain MySQL credentials.
# - Application files in `/home/ubuntu/php-app`.

# Author:    Oswaldo Solano
# Date:      01/Feb/2025
# Version:   1.0

# Variables
MYSQL_HOST="srv-bd.gowebsite.info"
# MYSQL_HOST="192.168.56.6"
MYSQL_DATABASE="dbtest"

# Update packages and install Docker and AWS CLI
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

# Configure AWS credentials (only if IAM roles are not used)
export AWS_ACCESS_KEY_ID="XXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXX"
export AWS_DEFAULT_REGION="us-east-1"

# Retrieve secrets from AWS Secrets Manager for MySQL connection
MYSQL_ADMIN_CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id mysql-admin-credentials --query SecretString --output text)
ADMIN_USERNAME=$(echo "$MYSQL_ADMIN_CREDENTIALS" | jq -r '.username')
ADMIN_PASSWORD=$(echo "$MYSQL_ADMIN_CREDENTIALS" | jq -r '.password')

# Retrieve secrets from AWS Secrets Manager for demo user
DEMO_USER_CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id demo-user-credentials --query SecretString --output text)
DEMO_USERNAME=$(echo "$DEMO_USER_CREDENTIALS" | jq -r '.username')
DEMO_PASSWORD=$(echo "$DEMO_USER_CREDENTIALS" | jq -r '.password')

# Go to the application directory
cd /home/ubuntu/repo || exit
# cd /home/vagrant || exit

# Build the Docker image
docker build -t php-app -f srv-web/Dockerfile .
# docker build -t php-app .

# Run the Docker container with the environment variables
docker run -d -p 80:80 --name apache-php-ct \
  --restart unless-stopped \
  -e MYSQL_HOST="$MYSQL_HOST" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  -e ADMIN_USERNAME="$ADMIN_USERNAME" \
  -e ADMIN_PASSWORD="$ADMIN_PASSWORD" \
  -e DEMO_USERNAME="$DEMO_USERNAME" \
  -e DEMO_PASSWORD="$DEMO_PASSWORD" \
  php-app

# Clean up installation and temporary files
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /home/ubuntu/repo/*.zip
sudo rm -rf /home/ubuntu/repo/aws