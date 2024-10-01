# Terraproject

## Description

Terraproject is an infrastructure-as-code project using Terraform to deploy an AWS Virtual Private Cloud (VPC) with multiple subnets, security groups, and EC2 instances. The project aims to provide a scalable and secure network architecture for hosting applications in AWS.

## Features

- Creates a VPC with customizable CIDR block.
- Deploys multiple subnets with specified CIDR blocks.
- Sets up an Internet Gateway for external access.
- Configures a route table to manage traffic between the subnets and the Internet.
- Configures security groups to manage inbound and outbound traffic.
- Automatically fetches the latest Amazon Linux AMI for EC2 instances.
- Launches EC2 instances with user data for initial setup.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An AWS account with appropriate IAM permissions to create VPCs, subnets, security groups, and EC2 instances.
- AWS CLI configured with your credentials. You can set this up by running:
  ```bash
  aws configure
