#!/bin/bash

name=`grep ipv4_address ./terraform.tfstate \
  | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'`
ssh -t p9mk@$name -- "pf9ctl detach-node;pf9ctl delete-cluster -n p9mk"
docker run -v `pwd`:/tf -w /tf hashicorp/terraform:1.1.7 destroy -auto-approve
rm -rf ./.terraform .terraform.lock.hcl terraform.tfstate*
read -p "Delete personal files (y/n)?" choice
case "$choice" in
  y|Y ) rm ssh.pub terraform.tfvars vm_data.yaml;;
  n|N ) echo "Keep personal files ...";;
  * ) echo "Skipped";;
esac
