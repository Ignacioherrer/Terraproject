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

resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = var.tag
}


    
    