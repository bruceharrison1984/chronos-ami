#!/bin/bash
set -e

echo -e "\n-= Create DB-Sync Service =-"
sudo sh -c "cat <<EOF > /etc/systemd/system/cardano-db-sync.service
# The Cardano DB Sync service (part of systemd)
# This service should only be used with cardano-relay, and never on a block producer
# file: /etc/systemd/system/cardano-db-sync.service

[Unit]
Description     = Cardano DB Sync service
Wants           = cardano-relay.target
After           = cardano-relay.target 

[Service]
User            = ${USERNAME}
Type            = simple
WorkingDirectory= ${NODE_HOME}
ExecStart       = /bin/bash -c '${NODE_HOME}/scripts/start-db-sync.sh'
KillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5
SyslogIdentifier=cardano-db-sync

[Install]
WantedBy	= multi-user.target
EOF"
sudo chmod 644 /etc/systemd/system/cardano-db-sync.service

echo -e "\n-= Create Block Producer Service =-"
sudo sh -c "cat <<EOF > /etc/systemd/system/cardano-block-producer.service
# The Cardano node service (part of systemd)
# file: /etc/systemd/system/cardano-block-producer.service 

[Unit]
Description     = Cardano node service
Wants           = network-online.target
Wants           = prometheus-to-cloudwatch.target
After           = network-online.target

[Service]
User            = ${USERNAME}
Type            = simple
WorkingDirectory= ${NODE_HOME}
ExecStart       = /bin/bash -c '${NODE_HOME}/scripts/start-block-producer.sh'
KillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5
SyslogIdentifier=cardano-block-producer

[Install]
WantedBy	= multi-user.target
EOF"
sudo chmod 644 /etc/systemd/system/cardano-block-producer.service

echo -e "\n-= Create Relay Service =-"
sudo sh -c "cat <<EOF > /etc/systemd/system/cardano-relay.service
# The Cardano node service (part of systemd)
# file: /etc/systemd/system/cardano-relay.service 

[Unit]
Description     = Cardano node service
Wants           = network-online.target
Wants           = prometheus-to-cloudwatch.target
After           = network-online.target 

[Service]
User            = ${USERNAME}
Type            = simple
WorkingDirectory= ${NODE_HOME}
ExecStart       = /bin/bash -c '${NODE_HOME}/scripts/start-relay.sh'
KillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5
SyslogIdentifier=cardano-relay

[Install]
WantedBy	= multi-user.target
EOF"
sudo chmod 644 /etc/systemd/system/cardano-relay.service

echo -e "\n-= Create Prometheus-To-Cloudwatch Service =-"
sudo sh -c "cat <<EOF > /etc/systemd/system/prometheus-to-cloudwatch.service

[Unit]
Description     = Prometheus-To-Cloudwatch service
After           = cardano-relay.target 

[Service]
User            = ${USERNAME}
Type            = simple
WorkingDirectory= ${NODE_HOME}/scripts
ExecStart       = /bin/bash -c '${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.sh'
KillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5
SyslogIdentifier=prometheus-to-cloudwatch

[Install]
WantedBy	= multi-user.target
EOF"
sudo chmod 644 /etc/systemd/system/prometheus-to-cloudwatch.service

echo -e "\n-= Reload Systemctl and disable services =-"
echo -e "-= You must manually enable the services after starting the image =-"
sudo systemctl daemon-reload
sudo systemctl disable cardano-relay
sudo systemctl disable cardano-block-producer
sudo systemctl disable cardano-db-sync
sudo systemctl disable prometheus-to-cloudwatch