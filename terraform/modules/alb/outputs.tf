#* Definición de Outputs

#* ARN del grupo de destinos (target group) del ALB
output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

#* Nombre DNS asignado para el Balanceador de Carga de Aplicaciones (ALB)
output "alb_dns_name" {
  value = aws_lb.app_load_balancer.dns_name
}

#* ID de la zona del Balanceador de Carga de Aplicaciones (ALB)
output "alb_zone_id" {
  value = aws_lb.app_load_balancer.zone_id
}
