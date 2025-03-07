#* Output Definitions

#* Security group ID assigned to the ALB
output "sg_alb_id" {
  value = aws_security_group.sg_alb.id
}

#* Security group ID assigned to the Apache-PHP instances
output "sg_srv_web_id" {
  value = aws_security_group.sg_srv_web.id
}

#* Security group ID assigned to the MySQL instance
output "sg_srv_mysql_id" {
  value = aws_security_group.sg_srv_mysql.id
}

#* Security group ID assigned to the Bastion instance
output "sg_bastion_id" {
  value = aws_security_group.sg_bastion.id
}
