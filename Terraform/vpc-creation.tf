provider "aws" {
  region  = "us-east-1"
  access_key = ""
  secret_key = ""
}

    resource "aws_vpc" "VPC-Auto" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "VPC-Auto"
  }
}

resource "aws_subnet" "Subnet-Public" {
  vpc_id     = aws_vpc.VPC-Auto.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Subnet-Public"
  }
}

resource "aws_subnet" "Subnet-Private" {
  vpc_id     = aws_vpc.VPC-Auto.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Subnet-Private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC-Auto.id

  tags = {
    Name = "igw"
  }
}

# Create the main route table for the VPC
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.VPC-Auto.id
   tags = {
    Name = "main"
  }
}

# Associate the private subnet with the main route table
resource "aws_route_table_association" "assoprivate" {
  subnet_id      = aws_subnet.Subnet-Private.id
  route_table_id = aws_route_table.main.id

 
}

# Create a custom route table for the public subnet with an internet gateway
resource "aws_route_table" "custom" {
  vpc_id = aws_vpc.VPC-Auto.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
    Name = "custom"
  }
}

# Associate the public subnet with the custom route table
resource "aws_route_table_association" "assopublic" {
  subnet_id      = aws_subnet.Subnet-Public.id
  route_table_id = aws_route_table.custom.id
}
