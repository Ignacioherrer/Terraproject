terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}

variable "vpc_cidr_block" {
  type = string
}

variable "tag" {
  type = map(string)
}


variable "subnet_cidr_block_1" {
  type = string
}

variable "subnet_cidr_block_2" {
  type = string
}

variable "subnet_cidr_block_3" {
  type = string
}
variable "image_name" {}
variable "instance_type" {}

resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = var.tag
}

resource "aws_subnet" "terraform-subnet-1" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = var.subnet_cidr_block_1
  tags       = var.tag
}

resource "aws_subnet" "terraform-subnet-2" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = var.subnet_cidr_block_2
  tags       = var.tag
}

output "terraform-vpc-id" {
  value = aws_vpc.terraform-vpc.id
}

resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "${var.tag["Name"]}-igw"
  }
}

resource "aws_route_table" "terraform-vpc-rt" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }
  tags = {
    Name = "${var.tag["Name"]}-rt"
  }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.terraform-subnet-1.id
  route_table_id = aws_route_table.terraform-vpc-rt.id
}

resource "aws_security_group" "allow_tls" {
  name   = "${var.tag["Name"]}-sg"
  vpc_id = aws_vpc.terraform-vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.terraform-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  tags = {
    Name = "${var.tag["Name"]}-server"
  }
}
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}