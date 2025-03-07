# Definition of Outputs

# Private IP assigned to the MySQL instance
output "ec2_mysql_private_ip" {
  value = aws_instance.ec2_mysql.private_ip
}

# Public IP assigned to the Bastion instance
output "ec2_bastion_public_ip" {
  value = aws_instance.ec2_bastion.public_ip
}
