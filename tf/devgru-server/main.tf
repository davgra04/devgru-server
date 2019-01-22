# Specify the provider and access details
provider "aws" {
  region = "us-west-2"
}

# Specify S3 as the state storage backend
terraform {
  backend "s3" {
    bucket = "devgru-tf-remote-state"
    key    = "devgru-server.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "dg_server_state" {
  backend = "s3"

  config {
    bucket = "devgru-tf-remote-state"
    key    = "devgru-server.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "infra_state" {
  backend = "s3"

  config {
    bucket = "devgru-tf-remote-state"
    key    = "infra.tfstate"
    region = "us-west-2"
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = "${data.terraform_remote_state.infra_state.vpc_id}"

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

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
  connection {
    user        = "centos"
    private_key = "${file(var.private_key_path)}"
  }

  instance_type = "t2.small"

  ami = "${lookup(var.aws_amis, var.aws_region)}"
  # ami = "ami-3ecc8f46"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${data.terraform_remote_state.infra_state.default_security_group_id}"]

  subnet_id = "${data.terraform_remote_state.infra_state.subnet_id}"

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/home/centos/bootstrap.sh"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/home/centos/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /home/centos/bootstrap.sh",
    ]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web.id}"
  allocation_id = "${data.terraform_remote_state.infra_state.devgru_server_eip_id}"

  tags {
      Name = "devgru_server_IP"
  }
}


