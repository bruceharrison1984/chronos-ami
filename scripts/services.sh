## we use envsubst as non-sudo because the proper envvars are already loaded in the ec2-user profile
#!/bin/bash
set -e

echo -e "\n-= Create DB-Sync Service =-"
envsubst < ${HOME}/setup/services/cardano-db-sync.service > ${HOME}/setup/services/cardano-db-sync.service
sudo cp ${HOME}/setup/services/cardano-db-sync.service /etc/systemd/system/cardano-db-sync.service
sudo chmod 644 /etc/systemd/system/cardano-db-sync.service

echo -e "\n-= Create Block Producer Service =-"
envsubst < ${HOME}/setup/services/cardano-block-producer.service > ${HOME}/setup/services/cardano-block-producer.service
sudo cp ${HOME}/setup/services/cardano-block-producer.service /etc/systemd/system/cardano-block-producer.service
sudo chmod 644 /etc/systemd/system/cardano-block-producer.service

echo -e "\n-= Create Relay Service =-"
envsubst < ${HOME}/setup/services/cardano-relay.service > ${HOME}/setup/services/cardano-relay.service
sudo cp ${HOME}/setup/services/cardano-relay.service /etc/systemd/system/cardano-relay.service
sudo chmod 644 /etc/systemd/system/cardano-relay.service

echo -e "\n-= Create Prometheus-To-Cloudwatch Service =-"
envsubst < ${HOME}/setup/services/prometheus-to-cloudwatch.service > ${HOME}/setup/services/prometheus-to-cloudwatch.service
sudo cp ${HOME}/setup/services/prometheus-to-cloudwatch.service /etc/systemd/system/prometheus-to-cloudwatch.service
sudo chmod 644 /etc/systemd/system/prometheus-to-cloudwatch.service

echo -e "\n-= Reload Systemctl and disable services =-"
echo -e "-= You must manually enable the services after starting the image =-"
sudo systemctl daemon-reload
sudo systemctl disable cardano-relay
sudo systemctl disable cardano-block-producer
sudo systemctl disable cardano-db-sync
sudo systemctl disable prometheus-to-cloudwatch