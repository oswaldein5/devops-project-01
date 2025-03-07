#* Definición de Outputs

#* ID del grupo de seguridad asignado para el ALB
output "sg_alb_id" {
  value = aws_security_group.sg_alb.id
}

#* ID del grupo de seguridad asignado para las instancias Apache-PHP
output "sg_srv_web_id" {
  value = aws_security_group.sg_srv_web.id
}

#* ID del grupo de seguridad asignado para la instancia MySQL
output "sg_srv_mysql_id" {
  value = aws_security_group.sg_srv_mysql.id
}

#* ID del grupo de seguridad asignado para la instancia Bastion
output "sg_bastion_id" {
  value = aws_security_group.sg_bastion.id
}
