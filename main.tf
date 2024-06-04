provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "linux-server-iit" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.lab6_security_group.id]
  user_data = <<-EOF
    #!bin/bash
    sudo yum update -y #
    sudo yum install -y docker
    sudo service docker start
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user
    sudo docker run -d --name lab456 -p 80:80 intestabilis/lab456
    sudo docker run -d --name watchtower --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower --interval 60
    EOF
}

resource "aws_security_group" "lab6_security_group" {
  name = "launch-wizard-2"
  description = "Allow ssh and http traffic"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "region" {
  type = string
  sensitive = true
  default = "eu-north-1"
}

variable "access_key" {
  type = string
  sensitive = true
  default = "AKIAVRUVVETM77EESRBX"
}

variable "secret_key" {
  type = string
  sensitive = true
  default = "1mDbaD8Mzc/TdcHuAw0SQNwZJmMhZv37wms7ylFA"
}

variable "ami" {
  type = string
  sensitive = true
  default = ""
}

variable "instance_type" {
  type = string
  sensitive = true
  default = "t3.micro"
}

variable "vpc_id" {
  type = string
  sensitive = true
  default = "vpc-0abf10afa3afab190"
}

variable "key_name" {
  type = string
  sensitive = true
  default = "linux-server-key"
}

#