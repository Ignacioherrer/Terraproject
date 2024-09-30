terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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
}
variable "subnet_cidr_block_2" { 
}

resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = var.tag
}

resource "aws_subnet" "terraform-subnet-1" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = var.subnet_cidr_block_1
  tags = var.tag
}

resource "aws_subnet" "terraform-subnet-2" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = var.subnet_cidr_block_2
  tags = var.tag
}
    
    