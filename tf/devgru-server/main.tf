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

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${data.terraform_remote_state.infra_state.default_security_group_id}"]

  subnet_id = "${data.terraform_remote_state.infra_state.subnet_id}"

  provisioner "file" {
    source      = "dgserv"
    destination = "/home/centos/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /home/centos/dgserv/bootstrap.sh",
    ]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web.id}"
  allocation_id = "${data.terraform_remote_state.infra_state.devgru_server_eip_id}"
}


