output "instance_address" {
  value = "${aws_instance.web.public_ip}"
}

output "instance_eip" {
    value = "${data.terraform_remote_state.infra_state.devgru_server_eip_id}"
}

# output "default_security_group" {
#   value = "${aws_security_group.devgru-server-sg.id}"
# }
