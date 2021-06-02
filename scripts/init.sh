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

echo -e "\n-= Setup EnvVars =-"
echo export NODE_HOME=${NODE_HOME} >> $HOME/.bashrc
echo export NODE_CONFIG=${NODE_CONFIG} >> $HOME/.bashrc
echo export CARDANO_DB_PATH="${NODE_HOME}/db" >> $HOME/.bashrc
echo export CARDANO_NODE_SOCKET_PATH="${CARDANO_DB}/socket" >> $HOME/.bashrc
echo export NODE_PORT="6000" >> $HOME/.bashrc