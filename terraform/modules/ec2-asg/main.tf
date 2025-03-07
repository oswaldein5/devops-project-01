#* Módulo para crear las Instancias EC2 (Apache-PHP, MySQL, Bastion) con Auto Scaling Group

#* Crear Launch Template para instancias EC2 (Apache-PHP)
resource "aws_launch_template" "ec2_srv_web" {
  name          = "srv-web-"
  image_id      = var.ec2_specs[0].ami # Ubuntu Server 24.04 LTS
  instance_type = var.ec2_specs[0].instance_type
  key_name      = data.aws_key_pair.key.key_name # Llave pre-definida en el portal AWS

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.sg_srv_web_id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Clonar el repositorio Git
    GIT_REPO_URL="${var.git_repo_url}"
    BRANCH="${var.git_branch}"

    for i in {1..5}; do
        git clone --no-checkout --branch $BRANCH $GIT_REPO_URL /home/ubuntu/EcolacMigracion && break || {
            echo "Retrying git clone ($i)..."
            sleep 10
        }
    done || {
        echo "Failed to clone repository after 5 attempts"
        exit 1
    }

    cd /home/ubuntu/EcolacMigracion

    # Configurar sparse-checkout para clonar solo carpetas específicas
    git sparse-checkout init --cone
    git sparse-checkout set app-ecolac-fuentes srv-web

    # Actualizar el repositorio para obtener solo las carpetas especificadas
    git checkout

    # Otorgar permisos de ejecución al script de instalación
    chmod +x /home/ubuntu/EcolacMigracion/srv-web/scripts/setup-srv-web.sh || {
      echo "Failed to chmod the setup script"
      exit 1
    }

    # Ejecutar el script de instalación
    /home/ubuntu/EcolacMigracion/srv-web/scripts/setup-srv-web.sh || {
      echo "Failed to execute setup script"
      exit 1
    }
    EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [var.internet_gateway_id]

  tags = {
    Name = "srv-web-${var.sufix}"
  }
}

#* Crear Auto Scaling Group para instancias EC2 (Apache-PHP)
resource "aws_autoscaling_group" "ec2_asg" {
  name              = "ec2-asg"
  min_size          = var.min_instances
  max_size          = var.max_instances
  desired_capacity  = var.min_instances
  target_group_arns = [var.alb_target_group_arn]

  vpc_zone_identifier = [
    var.private_subnet_ids[0],
    var.private_subnet_ids[1]
  ]

  launch_template {
    id      = aws_launch_template.ec2_srv_web.id
    version = "$Latest"
  }

  health_check_type = "EC2"

}

#* Crear Auto Scaling Policies para el Auto Scaling Group
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

#* Crear Auto Scaling Policies para el Auto Scaling Group
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

#* Crear Alarmas de CloudWatch para el Auto Scaling Group (cpu > 70% -> scale up)
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }
}

#* Crear Alarmas de CloudWatch para el Auto Scaling Group (cpu < 50% -> scale down)
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low_cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }
}

#* Crear Instancia EC2 (MySQL)
resource "aws_instance" "ec2_mysql" {
  ami                    = var.ec2_specs[0].ami # Ubuntu Server 24.04 LTS
  instance_type          = var.ec2_specs[0].instance_type
  subnet_id              = var.private_subnet_ids[2]
  key_name               = data.aws_key_pair.key.key_name # Llave pre-definida en el portal AWS
  vpc_security_group_ids = [var.sg_srv_mysql_id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Clonar el repositorio Git
    GIT_REPO_URL="${var.git_repo_url}"
    BRANCH="${var.git_branch}"

    for i in {1..5}; do
        git clone --no-checkout --branch $BRANCH $GIT_REPO_URL /home/ubuntu/EcolacMigracion && break || {
            echo "Retrying git clone ($i)..."
            sleep 10
        }
    done || {
        echo "Failed to clone repository after 5 attempts"
        exit 1
    }

    cd /home/ubuntu/EcolacMigracion

    # Configurar sparse-checkout para clonar solo carpetas específicas
    git sparse-checkout init --cone
    git sparse-checkout set srv-bd

    # Actualizar el repositorio para obtener solo las carpetas especificadas
    git checkout

    # Otorgar permisos de ejecución al script de instalación
    chmod +x /home/ubuntu/EcolacMigracion/srv-bd/scripts/setup-srv-bd.sh || {
      echo "Failed to chmod the setup script"
      exit 1
    }

    # Ejecutar el script de instalación
    /home/ubuntu/EcolacMigracion/srv-bd/scripts/setup-srv-bd.sh || {
      echo "Failed to execute setup script"
      exit 1
    }
    EOF
  )

  depends_on = [var.internet_gateway_id]

  tags = {
    Name = "srv-bd-${var.sufix}"
  }
}

#* Crear Instancia EC2 (Bastion) para comprobar todas las demás instancias a través de SSH
resource "aws_instance" "ec2_bastion" {
  ami                         = var.ec2_specs[1].ami # Amazon Linux 2
  instance_type               = var.ec2_specs[1].instance_type
  subnet_id                   = var.public_subnet_bastion_id
  key_name                    = data.aws_key_pair.key.key_name # Llave pre-definida en el portal AWS
  vpc_security_group_ids      = [var.sg_bastion_id]
  associate_public_ip_address = true

  tags = {
    "Name" = "bastion-${var.sufix}"
  }
}
