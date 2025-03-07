# Definition of Outputs

# ARN of the target group of the ALB
output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

# DNS name assigned to the Application Load Balancer (ALB)
output "alb_dns_name" {
  value = aws_lb.app_load_balancer.dns_name
}

# Zone ID of the Application Load Balancer (ALB)
output "alb_zone_id" {
  value = aws_lb.app_load_balancer.zone_id
}
