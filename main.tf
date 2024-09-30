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

data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_subnet" "terraform-subnet-3" {
  vpc_id     = data.aws_vpc.default_vpc.id
  cidr_block = var.subnet_cidr_block_3
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

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  
  tags = {
    Name = "${var.tag["Name"]}-rt"
  }
}