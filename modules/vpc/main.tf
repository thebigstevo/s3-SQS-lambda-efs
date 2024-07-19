# VPC
resource "aws_vpc" "s3toefs-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)

  cidr_block        = var.subnet_cidrs[count.index]
  vpc_id            = aws_vpc.s3toefs-vpc.id
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.s3toefs-vpc.id
  tags = {
    Name = "${var.project_name}-internet-gateway"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.s3toefs-vpc.id
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

# Route Table Association (use dynamic block for subnet associations)
resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.availability_zones)

  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}