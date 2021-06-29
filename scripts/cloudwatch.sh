#!/bin/bash
set -e

CLOUDWATCH_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo -e "\n-= Setup Cloudwatch Agent =-"
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo mv ${HOME}/setup/config/amazon-cloudwatch-agent.json ${CLOUDWATCH_CONFIG}
sudo yum install -y amazon-cloudwatch-agent
sudo gpasswd --add cwagent cardano
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:${CLOUDWATCH_CONFIG}
sudo systemctl enable amazon-cloudwatch-agent.service

echo -e "\n-= Grant cwagent permission to read log streams =-"
sudo setfacl -m u:cwagent:xr /var/log/messages
sudo setfacl -m u:cwagent:xr /var/log/secure
sudo setfacl -m u:cwagent:xr /var/log/cloud-init-output.log
sudo setfacl -m u:cwagent:xr /var/log/fail2ban.log