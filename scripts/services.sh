#!/bin/bash
set -e

echo -e "\n-= Create Block Producer Service =-"
cat > ${NODE_HOME}/cardano-block-producer.service << EOF 
# The Cardano node service (part of systemd)
# file: /etc/systemd/system/cardano-block-producer.service 

[Unit]
Description     = Cardano node service
Wants           = network-online.target
After           = network-online.target 

[Service]
User            = ${USERNAME}
Type            = simple
WorkingDirectory= ${NODE_HOME}
ExecStart       = /bin/bash -c '${NODE_HOME}/scripts/start-block-producer.sh'
KillSignal=SIGINT
RestartKillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5
SyslogIdentifier=cardano-block-producer

[Install]
WantedBy	= multi-user.target
EOF
sudo mv $NODE_HOME/cardano-block-producer.service /etc/systemd/system/cardano-block-producer.service
sudo chmod 644 /etc/systemd/system/cardano-block-producer.service

echo -e "\n-= Create Relay Service =-"
cat > ${NODE_HOME}/cardano-relay.service << EOF 
# The Cardano node service (part of systemd)
# file: /etc/systemd/system/cardano-relay.service 

[Unit]
Description     = Cardano node service
Wants           = network-online.target
After           = network-online.target 

[Service]
User            = ${USERNAME}
Type            = simple
WorkingDirectory= ${NODE_HOME}
ExecStart       = /bin/bash -c '${NODE_HOME}/scripts/start-relay.sh'
KillSignal=SIGINT
RestartKillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5
SyslogIdentifier=cardano-relay

[Install]
WantedBy	= multi-user.target
EOF
sudo mv $NODE_HOME/cardano-relay.service /etc/systemd/system/cardano-relay.service
sudo chmod 644 /etc/systemd/system/cardano-relay.service

echo -e "\n-= Reload Systemctl and enable cardano-relay =-"
echo -e "-= If this is to be a block-producer, you must manually enable the service =-"
sudo systemctl daemon-reload
sudo systemctl disable cardano-relay