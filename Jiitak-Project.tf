terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  access_key = "access_key"
  secret_key = "secret_key"
}

resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 0
    to_port     = 65535
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

resource "aws_instance" "Jiitak-Project-Jenkins" {
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t2.micro"
  key_name = "project"
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install fontconfig openjdk-17-jre -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
systemctl status jenkins
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
EOF

  tags = {
    Name = "Jiitak-Project-Jenkins"
  }
}

resource "aws_instance" "Jiitak-Project-Docker" {
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t2.micro"
  key_name = "project"
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu
EOF

  tags = {
    Name = "Jiitak-Project-Docker"
  }
