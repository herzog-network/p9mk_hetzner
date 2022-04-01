#!/bin/bash

echo -ne 'Prepare ... \r'
sleep 1

# Hetzner API key
FILE=./terraform.tfvars
if [ -f "$FILE" ]; then
  echo -ne '#####                     (33%)\r'
  sleep 1
else
  echo 'Insert your Hetzner API key'
  read api
  echo hcloud_token = \"$api\" > ./terraform.tfvars
fi

# SSH public key
FILE=./ssh.pub
if [ -f "$FILE" ]; then
  echo -ne '#############             (66%)\r'
  sleep 1
else
  echo 'Insert your SSH public key - e.g.: ssh-ed25519 AAAAC3N...'
  read ssh
  echo $ssh > ./ssh.pub
fi

# cloudinit
FILE=./vm_data.yaml
if [ -f "$FILE" ]; then
  echo -ne '#######################   (100%)\r'
  sleep 1
else
  cat > ./vm_data.yaml << EOF
#cloud-config
users:
  - name: p9mk
    groups: users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh}
package_update: true
package_upgrade: true
packages:
  - curl
runcmd:
  - sed -ie '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -ie '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -ie '/^X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
  - sed -ie '/^#MaxAuthTries/s/^.*$/MaxAuthTries 2/' /etc/ssh/sshd_config
  - sed -ie '/^#AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
  - sed -ie '/^#AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
  - sed -ie '/^#AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh/authorized_keys/' /etc/ssh/sshd_config
  - sed -i '$a AllowUsers p9mk' /etc/ssh/sshd_config
  - systemctl restart ssh
EOF
fi

# TF init
echo -ne 'Init ...                        \r'
sleep 1
docker run -v `pwd`:/tf -w /tf hashicorp/terraform:1.1.7 init

# TF apply
echo -ne 'Deploy ...                       \r'
sleep 1

docker run -v `pwd`:/tf -w /tf hashicorp/terraform:1.1.7 apply -auto-approve
echo Wait 30s
sleep 30

#Platform9 init
name=`grep ipv4_address ./terraform.tfstate \
  | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'`
cat p9ctl.sh | ssh p9mk@$name;ssh -t p9mk@$name -- "pf9ctl config set;pf9ctl check-node;pf9ctl bootstrap p9mk --pmk-version 1.21.3-pmk.72"
