# output "address" {
#   value = "${aws_instance.web.public_ip}"
# }

output "vpc_id" {
    value = "${aws_vpc.devgru-server-vpc.id}"
}

output "default_security_group_id" {
    value = "${aws_security_group.devgru-server-sg.id}"
}

output "subnet_id" {
    value = "${aws_subnet.devgru-server-subnet.id}"
}


output "devgru_server_eip_public_ip" {
    value = "${aws_eip.devgru-server-eip.public_ip}"
}
