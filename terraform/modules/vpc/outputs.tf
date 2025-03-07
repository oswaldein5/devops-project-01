#* Definición de Outputs

#* ID asignado al VPC existente
output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

#* IDs asignados a las subredes públicas
output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

#* IDs asignados a las subredes privadas
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}

#* ID asignado al Internet Gateway
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
