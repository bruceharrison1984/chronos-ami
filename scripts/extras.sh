#!/bin/bash
set -e

echo -e "\n-= Install Google Authentication =-"
echo -e "-= (This needs to be manually setup once you start a server with this image) =-"
sudo yum -y install google-authenticator qrencode

echo -e "\n-= Install Fail2Ban =-"
sudo yum install -y fail2ban
sudo systemctl enable fail2ban
sudo sh -c 'cat <<EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = ssh
action = iptables-multiport
logpath = /var/log/secure
maxretry = 3
bantime = 600
EOF'

echo -e "\n-= Setup MOTD =-"
sudo sh -c 'cat <<EOF > /etc/update-motd.d/30-banner
                          __|  __|_  )
                          _|  (     /   Amazon Linux 2 AMI
                          ___|\___|___|
       ____    _    ____  ____    _    _   _  ___          _    __  __ ___ 
      / ___|  / \  |  _ \|  _ \  / \  | \ | |/ _ \        / \  |  \/  |_ _|
     | |     / _ \ | |_) | | | |/ _ \ |  \| | | | |_____ / _ \ | |\/| || | 
     | |___ / ___ \|  _ <| |_| / ___ \| |\  | |_| |_____/ ___ \| |  | || | 
      \____/_/   \_\_| \_\____/_/   \_\_| \_|\___/     /_/   \_\_|  |_|___|
                      * EXPERIMENTAL -USE AT OWN RISK-*
EOF'