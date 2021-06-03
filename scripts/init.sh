#!/bin/bash
set -e

CLOUDWATCH_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo -e "\n-= Update existing packages =-"
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y

echo -e "\n-= Setup Cloudwatch Agent =-"
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo cp ${HOME}/setup/amazon-cloudwatch-agent.json ${CLOUDWATCH_CONFIG}
sudo yum install -y amazon-cloudwatch-agent
sudo gpasswd --add cwagent adm
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:${CLOUDWATCH_CONFIG}
sudo systemctl enable amazon-cloudwatch-agent.service

echo -e "\n-= Create ${USERNAME} user account"
sudo adduser ${USERNAME} -m -s /bin/bash
sudo passwd -d ${USERNAME}

echo -e "\n-= Create ${NODE_HOME} directory =-"
sudo mkdir ${NODE_HOME}/scripts -p
sudo mkdir ${NODE_HOME}/keys -p
sudo mkdir ${NODE_HOME}/config -p
sudo mkdir ${NODE_HOME}/db -p
sudo mkdir ${NODE_HOME}/ipc -p