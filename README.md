devgru-server
=============

A terraform project for deploying personal-use web applications.

# Getting Started

## Create Remote State Bucket

This portion is responsible for the S3 bucket used to store terraform remote states. Keeping track of the `.tfstate` file for this part is not critical, just delete the single bucket by hand via the S3 console.

```bash
cd tf/state-bucket

# deploy with terraform
terraform init
terraform apply -auto-approve
```

## Create Infrastructure

This portion covers the infrastructre (VPC, subnet, elastic IP, etc).

```bash
cd tf/infra

# deploy with terraform
terraform init
terraform apply -auto-approve

# destroy
terraform destroy -auto-approve

```

## Create devgru-server

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





```
# (optional) tf apply test websites (adds nginx config and deploys)
```
