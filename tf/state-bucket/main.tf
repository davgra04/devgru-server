provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "dgserver-remote-state-key" {
  description             = "This key is used to encrypt the terraform remote state for the infrastructure"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "state-bucket" {
  bucket = "devgru-tf-remote-state"
  acl    = "private"

  tags = {
    Name        = "devgru-tf-remote-state"
    # Environment = "Dev"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.dgserver-remote-state-key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}



# # Specify the provider and access details
# provider "aws" {
#   region = "${var.aws_region}"
# }

# # Specify S3 as the state storage backend
# terraform {
#   backend "s3" {}
# }

# data "terraform_remote_state" "network" {
#   backend = "s3"
#   config {
#     bucket = "${var.remote_state_bucket}"
#     key    = "infra.tfstate"
#     region = "${var.aws_region}"
#   }
# }

# # Create a VPC to launch our instances into
# resource "aws_vpc" "default" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create an internet gateway to give our subnet access to the outside world
# resource "aws_internet_gateway" "default" {
#   vpc_id = "${aws_vpc.default.id}"
# }

# # Grant the VPC internet access on its main route table
# resource "aws_route" "internet_access" {
#   route_table_id         = "${aws_vpc.default.main_route_table_id}"
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = "${aws_internet_gateway.default.id}"
# }

# # Create a subnet to launch our instances into
# resource "aws_subnet" "default" {
#   vpc_id                  = "${aws_vpc.default.id}"
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
# }


# # Our default security group to access
# # the instances over SSH and HTTP
# resource "aws_security_group" "default" {
#   name        = "terraform_example"
#   description = "Used in the terraform"
#   vpc_id      = "${aws_vpc.default.id}"

#   # SSH access from my IP
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["73.136.21.62/32"]
#   }

#   # HTTP access from my IP
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["73.136.21.62/32"]
#   }

#   # outbound internet access
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_key_pair" "auth" {
#   key_name   = "${var.key_name}"
#   public_key = "${file(var.public_key_path)}"
# }

# resource "aws_instance" "web" {
#   connection {
#     user = "centos"
#     private_key = "${file(var.private_key_path)}"
#   }

#   instance_type = "t2.micro"

#   ami = "${lookup(var.aws_amis, var.aws_region)}"

#   key_name = "${aws_key_pair.auth.id}"

#   vpc_security_group_ids = ["${aws_security_group.default.id}"]

#   subnet_id = "${aws_subnet.default.id}"

#   provisioner "file" {
#     source      = "bootstrap.sh"
#     destination = "/home/centos/bootstrap.sh"
#   }


#   provisioner "remote-exec" {
#     inline = [
#       "sudo bash /home/centos/bootstrap.sh"
#     ]
#   }
# }
