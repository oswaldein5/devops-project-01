#* Módulo para crear todos los recursos necesarios para la Virtual Private Cloud (VPC)

#* Recurso para crear una VPC en AWS con soporte de DNS y etiquetas
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.virginia_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-${var.sufix}"
  }
}

#* Recurso para crear una subred pública por cada zona de disponibilidad en la región us-east-1
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_main.id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.vpc_main.cidr_block, 8, count.index + 1)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags = {
    Name = "publ-subnet-${var.sufix}"
  }
}

#* Recurso para crear una subred privada por cada zona de disponibilidad en la región us-east-1
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_main.id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.vpc_main.cidr_block, 8, count.index + 4)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags = {
    Name = "priv-subnet-${var.sufix}"
  }
}

#* Recurso para crear una puerta de enlace de internet (Internet Gateway)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw-${var.sufix}"
  }
}

#* Recurso para crear un NAT gateway para la subred pública en la zona de disponibilidad us-east-1a
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)

  tags = {
    Name = "nat-gateway-${var.sufix}"
  }

  depends_on = [aws_internet_gateway.igw]
}

#* Recurso para crear una dirección IP elástica (Elastic IP) para el NAT Gateway
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "eip-${var.sufix}"
  }

  depends_on = [aws_internet_gateway.igw]
}

#* Recurso para crear una tabla de rutas (Route Table) para subredes públicas
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "public-rt-${var.sufix}"
  }
}

#* Asociación de la tabla de rutas pública a las subredes públicas
resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.public_rt.id
  count          = length(var.vpc_availability_zones)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}

#* Recurso para crear una tabla de rutas (Route Table) para subredes privadas
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  depends_on = [aws_nat_gateway.nat_gateway]

  tags = {
    Name = "private-rt-${var.sufix}"
  }
}

#* Asociación de la tabla de rutas privada a las subredes privadas
resource "aws_route_table_association" "private_subnet_association" {
  route_table_id = aws_route_table.private_rt.id
  count          = length(var.vpc_availability_zones)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}
