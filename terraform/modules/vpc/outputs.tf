# Definition of Outputs

# ID assigned to the existing VPC
output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

# IDs assigned to the public subnets
output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

# IDs assigned to the private subnets
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}

# ID assigned to the Internet Gateway
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
