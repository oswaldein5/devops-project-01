#* Definición de Outputs

#* IP privada asignada a la instancia MySQL
output "ec2_mysql_private_ip" {
  value = aws_instance.ec2_mysql.private_ip
}

#* IP pública asignada a la instancia Bastion
output "ec2_bastion_public_ip" {
  value = aws_instance.ec2_bastion.public_ip
}
