# Module to create all necessary resources for the Virtual Private Cloud (VPC)

# Resource to create a VPC in AWS with DNS support and tags
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.virginia_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-${var.sufix}"
  }
}

# Resource to create a public subnet for each availability zone in the us-east-1 region
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_main.id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.vpc_main.cidr_block, 8, count.index + 1)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags = {
    Name = "publ-subnet-${var.sufix}"
  }
}

# Resource to create a private subnet for each availability zone in the us-east-1 region
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_main.id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.vpc_main.cidr_block, 8, count.index + 4)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags = {
    Name = "priv-subnet-${var.sufix}"
  }
}

# Resource to create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw-${var.sufix}"
  }
}

# Resource to create a NAT gateway for the public subnet in the us-east-1a availability zone
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)

  tags = {
    Name = "nat-gateway-${var.sufix}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Resource to create an Elastic IP for the NAT Gateway
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "eip-${var.sufix}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Resource to create a Route Table for public subnets
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

# Association of the public route table to the public subnets
resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.public_rt.id
  count          = length(var.vpc_availability_zones)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}

# Resource to create a Route Table for private subnets
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

# Association of the private route table to the private subnets
resource "aws_route_table_association" "private_subnet_association" {
  route_table_id = aws_route_table.private_rt.id
  count          = length(var.vpc_availability_zones)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}
