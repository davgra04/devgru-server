# variable "remote_state_bucket" {
#   description = "Name of the remote state bucket"
#   default     = "devgru-tf-remote-state"
# }

# variable "remote_state_key" {
#   description = "Name of the remote state key"
#   default     = "devgru-server"
# }

# variable "infra_remote_state_key" {
#   description = "Name of the remote state key"
#   default     = "infra"
# }

variable "public_key_path" {}

variable "private_key_path" {}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "us-west-2"
}

# CentOS 7 (x86_64) - with Updates HVM
variable "aws_amis" {
  default = {
    ap-northeast-1 = "ami-8e8847f1"
    ap-northeast-2 = "ami-bf9c36d1"
    ap-southeast-1 = "ami-8e0205f2"
    ap-southeast-2 = "ami-d8c21dba"
    ca-central-1   = "ami-e802818c"
    eu-central-1   = "ami-dd3c0f36"
    eu-north-1     = "ami-b133bccf"
    eu-west-1      = "ami-3548444c"
    eu-west-2      = "ami-00846a67"
    eu-west-3      = "ami-262e9f5b"
    sa-east-1      = "ami-cb5803a7"
    us-east-1      = "ami-9887c6e7"
    us-east-2      = "ami-9c0638f9"
    us-west-1      = "ami-4826c22b"
    us-west-2      = "ami-3ecc8f46"
  }
}

variable "my_ip" {
  description = "Used for setting ssh and http/https access for my machine"
  default = "73.136.21.62"
}
