#!/bin/bash
set -e

echo -e "\n-= Update existing packages =-"
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y
sudo yum install -y jq moreutils git
sudo -H pip3 install yq 
sudo amazon-linux-extras install postgresql10

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

echo -e "\n-= Create ${USERNAME} user account"
sudo adduser ${USERNAME} -m -s /bin/bash
sudo passwd -d ${USERNAME}

echo -e "\n-= Create ${NODE_HOME} directory =-"
sudo mkdir ${NODE_HOME} -p

echo -e "\n-= Make ec2-user owner of ${NODE_HOME} directory for installation =-"
sudo chown -R ec2-user ${NODE_HOME}

echo -e "\n-= Create ${NODE_HOME} subdirectories =-"
mkdir ${NODE_HOME}/scripts -p
mkdir ${NODE_HOME}/keys -p
mkdir ${NODE_HOME}/config -p
mkdir ${NODE_HOME}/db -p
mkdir ${NODE_HOME}/ipc -p
mkdir ${NODE_HOME}/logs -p
mkdir ${NODE_HOME}/sync/schema -p

echo -e "\n-= Create dummy PGPASS file =-"
echo "hostname:port:database:username:password" | tee ${NODE_HOME}/config/pgpass-mainnet
chmod 600 ${NODE_HOME}/config/pgpass-mainnet

echo -e "\n-= Create .env Script =-"
cat <<EOF > ${NODE_HOME}/scripts/.env
#!/bin/bash
export NODE_HOME=${NODE_HOME}
export NODE_CONFIG=${NODE_CONFIG}
export CARDANO_DB_PATH="${NODE_HOME}/db"
export CARDANO_NODE_SOCKET_PATH="${NODE_HOME}/ipc/node.socket"
export NODE_PORT="6000"
EOF
chmod +x ${NODE_HOME}/scripts/.env