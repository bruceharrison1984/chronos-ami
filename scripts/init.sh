#!/bin/bash
set -e

echo -e "\n-= Update existing packages =-"
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y
sudo yum install -y jq moreutils git
sudo amazon-linux-extras install postgresql10

echo -e "\n-= Create ${USERNAME} user account"
sudo adduser ${USERNAME} -m -s /bin/bash
sudo passwd -d ${USERNAME}

echo -e "\n-= Create ${NODE_HOME} directory =-"
sudo mkdir ${NODE_HOME}/scripts -p
sudo mkdir ${NODE_HOME}/keys -p
sudo mkdir ${NODE_HOME}/config -p
sudo mkdir ${NODE_HOME}/db -p
sudo mkdir ${NODE_HOME}/ipc -p
sudo mkdir ${NODE_HOME}/logs -p
sudo mkdir ${NODE_HOME}/sync/schema -p

echo -e "\n-= Create dummy PGPASS file =-"
echo "hostname:port:database:username:password" | sudo tee ${NODE_HOME}/config/pgpass-mainnet
sudo chmod 600 ${NODE_HOME}/config/pgpass-mainnet