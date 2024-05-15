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
  name        = "SG02"
  description = "Allow SSH and HTTP traffic"
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

# Create a launch template
resource "aws_launch_template" "example" {
  name_prefix   = "example-template-"
  image_id      = "ami-0bb84b8ffd87024d8"  # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "Key-govicloud@1"           # Replace with your key pair name

  # Other configuration options such as security groups, user data, etc. can be added here
}

# Create an auto-scaling group
resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  min_size             = 1
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = data.aws_subnets.default.ids  # Use the correct subnet IDs retrieved from the data source
}
