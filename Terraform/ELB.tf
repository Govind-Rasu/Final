
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
resource "aws_security_group" "SG01" {
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

# EC2 instance for Google server
resource "aws_instance" "googleserver" {
  ami                         = "ami-0bb84b8ffd87024d8"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.SG01.id]
  subnet_id                   = data.aws_subnets.default.ids[0]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              service httpd start
              wget google.com -O /var/www/html/index.html
              EOF

  tags = {
    Name = "Google server"
  }
}

# EC2 instance for Yahoo server
resource "aws_instance" "yahooServer" {
  ami                         = "ami-07caf09b362be10b8"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.SG01.id]
  subnet_id                   = data.aws_subnets.default.ids[0]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              service httpd start
              wget yahoo.com -O /var/www/html/index.html
              EOF

  tags = {
    Name = "YahooServer"
  }
}

# Load balancer
resource "aws_lb" "test" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG01.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "test-lb"
  }
}

# Target group
resource "aws_lb_target_group" "test" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Listener
resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

# Attach instances to the target group
resource "aws_lb_target_group_attachment" "google" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.googleserver.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "yahoo" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.yahooServer.id
  port             = 80
}
