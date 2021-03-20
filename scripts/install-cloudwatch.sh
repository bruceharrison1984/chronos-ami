#!/bin/bash
set -e

CLOUDWATCH_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo "-= Update existing packages & add EPEL repository =-"
sudo dnf update -y
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

echo "-= Install Cloudwatch Agent =-"
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo cp ~/setup_scripts/amazon-cloudwatch-agent.json ${CLOUDWATCH_CONFIG}
sudo dnf install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

echo "-= Start Cloudwatch Agent =-"
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:${CLOUDWATCH_CONFIG}

echo "-= Create Cardano User =-"
sudo adduser cardano --home /home/cardano --shell /bin/bash
sudo sh -c "echo 'cardano ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

echo "-= Grant cardano user access to setup scripts=-"
sudo chown -R cardano ~/setup_scripts
