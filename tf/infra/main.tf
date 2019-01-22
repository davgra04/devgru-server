# Specify the provider and access details
provider "aws" {
  region = "us-west-2"
}

# Specify S3 as the state storage backend
terraform {
  backend "s3" {
    bucket = "devgru-tf-remote-state"
    key = "infra.tfstate"
    region = "us-west-2"
  }
}

# data "terraform_remote_state" "network" {
#   backend = "s3"
#   config {
#     bucket = "${var.remote_state_bucket}"
#     key    = "${var.infra_remote_state_key}.tfstate"
#     region = "${var.aws_region}"
#   }
# }

# Create a VPC to launch our instances into
resource "aws_vpc" "devgru-server-vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
      Name = "devgru-server-VPC"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "devgru-server-ig" {
  vpc_id = "${aws_vpc.devgru-server-vpc.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.devgru-server-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.devgru-server-ig.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "devgru-server-subnet" {
  vpc_id                  = "${aws_vpc.devgru-server-vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "devgru-server-sg" {
  name        = "devgru-server-sg"
  # description = "Used in the terraform"
  vpc_id      = "${aws_vpc.devgru-server-vpc.id}"

  # SSH access from my IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.136.21.62/32"]
  }

  # HTTP access from my IP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["73.136.21.62/32"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "devgru-server-eip" {
  vpc = true
}

