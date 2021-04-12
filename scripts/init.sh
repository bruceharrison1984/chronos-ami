#!/bin/bash
set -e

CLOUDWATCH_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo "-= Create Cardano User =-"
sudo adduser cardano --home /home/cardano --shell /bin/bash
sudo sh -c "echo 'cardano ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

echo "-= Moving setup_scripts in to a more accessible location =-"
sudo mkdir /setup_scripts
sudo mv ~/setup_scripts/* /setup_scripts/
sudo chmod 755 /setup_scripts
sudo ls -lha /setup_scripts

echo "-= Update existing packages & add EPEL repository =-"
sudo dnf update -y
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

echo "-= Install Cloudwatch Agent =-"
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo cp /setup_scripts/amazon-cloudwatch-agent.json ${CLOUDWATCH_CONFIG}
sudo dnf install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

echo "-= Start Cloudwatch Agent =-"
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:${CLOUDWATCH_CONFIG}

echo "-= Install Google Authentication =-"
echo "-= (This needs to be manually setup once you start a server with this image) =-"
sudo dnf install google-authenticator qrencode -y

echo "-= Install Fail2Ban =-"
sudo dnf install -y fail2ban
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

echo "-= Setup first run MOTD =-"
sudo sh -c 'cat <<EOF > /etc/motd
       ____    _    ____  ____    _    _   _  ___          _    __  __ ___ 
      / ___|  / \  |  _ \|  _ \  / \  | \ | |/ _ \        / \  |  \/  |_ _|
     | |     / _ \ | |_) | | | |/ _ \ |  \| | | | |_____ / _ \ | |\/| || | 
     | |___ / ___ \|  _ <| |_| / ___ \| |\  | |_| |_____/ ___ \| |  | || | 
      \____/_/   \_\_| \_\____/_/   \_\_| \_|\___/     /_/   \_\_|  |_|___|
                      * EXPERIMENTAL -USE AT OWN RISK-*

Notes:
- Fail2Ban is installed with a basic configuration
  - This config will ban for 10 minutes. Change it if you desire different behavior
- Google Authenticator is installed
  - This must be manually configured in order to use it
- POOL_NAME is not set
  - Set it within $CNODE_HOME/scripts/env
- CNODE_PORT is set to 6000
  - Change it within $CNODE_HOME/scripts/env
- ec2-user login is enabled in order to securely deploy with AWS SSH keys the first time
  - You can remove/disable this user if you want, but make sure to setup a new SSH user first!
- cardano user has sudo permissions.
  - you probably want to remove these once you get your node up and running

               *disable this message by running "touch $HOME/.hushlogin*
EOF'