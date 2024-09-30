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
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"
}
