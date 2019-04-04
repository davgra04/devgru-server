devgru-server
=============

A terraform project for deploying personal-use web applications behind an Nginx reverse proxy.

![Sketch of devgruserver](/docs/sketch.png)


# Getting Started


## Create Remote State Bucket

This will create an S3 bucket for storing terraform remote state.

```bash
cd tf/state-bucket

# deploy with terraform
terraform init
terraform apply -auto-approve

# destroy
# Simply delete the bucket in the AWS console or aws-cli (Make sure this is the last thing destroyed when tearing everything down!)
```


## Create Infrastructure

This will create the VPC, internet gateway, route, subnet, security group, and elastic IP needed by the devgru-server instance

```bash
cd tf/infra

# deploy with terraform
terraform init
terraform apply -auto-approve

# destroy
terraform destroy -auto-approve

```


## Create devgru-server

This will create the EC2 instance and set up Nginx.

```bash
cd tf/devgru-server

# generate key for accessing EC2 instance
ssh-keygen -t rsa -C this-is-my-server-key -f ~/.ssh/devgruserver.key

# get your external IP
MY_IP=$(curl -s ifconfig.co)

# deploy with terraform
terraform init
terraform apply -var "key_name=~/.ssh/whatever" -var "private_key_path=~/.ssh/whatever.key" -var "public_key_path=~/.ssh/whatever.key.pub" -var "my_ip=${MY_IP}/32" -auto-approve

# destroy
terraform destroy -var "key_name=~/.ssh/whatever" -var "private_key_path=~/.ssh/whatever.key" -var "public_key_path=~/.ssh/whatever.key.pub" -var "my_ip=${MY_IP}/32" -auto-approve
```
