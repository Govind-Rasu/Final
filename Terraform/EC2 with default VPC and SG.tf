provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

# Data sources to retrieve default VPC and subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group definition
resource "aws_security_group" "SG02" {
  name        = "SG01"
  description = "SSH and HTTP security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance for Wikipedia server
resource "aws_instance" "Wikipediaserver" {
  ami                         = "ami-0bb84b8ffd87024d8"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.SG02.id]
  subnet_id                   = data.aws_subnets.default.ids[0]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              service httpd start
              wget wikipedia.com -O /var/www/html/index.html
              EOF

  tags = {
    Name = "Wikipedia server"
  }
}
