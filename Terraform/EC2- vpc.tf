# Define a security group
resource "aws_security_group" "SG02" {
  name        = "SG02"
  description = "SSH and ICMP security group"
  vpc_id      = aws_vpc.VPC-Auto.id

  // Define your security group rules here
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the EC2 instance
resource "aws_instance" "PublicServer" {
  ami                    = "ami-07caf09b362be10b8"  
  instance_type          = "t2.micro"
  associate_public_ip_address = true
  subnet_id              = aws_subnet.Subnet-Public.id
  security_groups        = [aws_security_group.SG02.id]

  // User data script
  user_data = <<-EOF
              #!/bin/bash
              sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
              sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo service sshd restart
              sudo echo 'root:Govi@123' | chpasswd
              hostname "PublicServer"
              EOF

  tags = {
    Name = "PublicServer"
  }
}

# Define the EC2 instance in a private subnet
resource "aws_instance" "PrivateServer" {
  ami                    = "ami-07caf09b362be10b8"  
  instance_type          = "t2.micro"
  associate_public_ip_address = true
  subnet_id              = aws_subnet.Subnet-Private.id
  security_groups        = [aws_security_group.SG02.id]

  // User data script
  user_data = <<-EOF
              #!/bin/bash
              sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
              sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo service sshd restart
              sudo echo 'root:Govi@123' | chpasswd
              hostname "PrivateServer"
              EOF

  tags = {
    Name = "PrivateServer"
  }
}


