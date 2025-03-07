# Module to create all necessary resources for the Application Load Balancer (ALB)

# Resource to create an Application Load Balancer (ALB)
resource "aws_lb" "app_load_balancer" {
  name                       = "app-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sg_alb_id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "alb-${var.sufix}"
  }
}

# Resource to create a target group for the ALB
resource "aws_lb_target_group" "alb_target_group" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "alb-target-group-${var.sufix}"
  }
}

# Resource to create an HTTP listener for the ALB
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "alb-listener-http-${var.sufix}"
  }
}

# Resource to create an HTTPS listener for the ALB
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # SSL security policy
  certificate_arn   = var.certificate_ssl_acm_arn # ARN of the SSL certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  tags = {
    Name = "alb-listener-https-${var.sufix}"
  }
}
