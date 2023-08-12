resource "aws_vpc" "Trial-VPC-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Trial-VPC-1"
  }
}

variable "subnet_cidr" {
  description = "Public subnet cidr block"
  default = "10.0.1.0/24"
  type = string
}


resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.Trial-VPC-1.id
  cidr_block = var.subnet_cidr
  tags = {
    "Name" = "Public-Subnet"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id                  = aws_vpc.Trial-VPC-1.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "Private Subnet"
  }
  availability_zone = "ap-south-1a"
}

resource "aws_network_acl" "TrialVPC-1-NACL" {
  vpc_id     = aws_vpc.Trial-VPC-1.id
  subnet_ids = [aws_subnet.PublicSubnet.id]
  egress {
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }
}


resource "aws_route_table" "RTB-12" {
  vpc_id = aws_vpc.Trial-VPC-1.id
  tags = {
    "Name" = "Route-Table-1"
  }
}

resource "aws_route" "Route-12" {
  route_table_id         = aws_route_table.RTB-12.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Internet-Gateway-1.id
}


resource "aws_internet_gateway" "Internet-Gateway-1" {
  vpc_id = aws_vpc.Trial-VPC-1.id
  tags = {
    "Name" = "Trial-VPC-IGW"
  }
}

resource "aws_main_route_table_association" "Main-Route-Table-Association-1" {
  vpc_id         = aws_vpc.Trial-VPC-1.id
  route_table_id = aws_route_table.RTB-12.id
}


