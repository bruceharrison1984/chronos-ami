## we use envsubst as non-sudo because the proper envvars are already loaded in the ec2-user profile
#!/bin/bash
set -e

echo -e "\n-= Create DB-Sync Service =-"
envsubst < ${HOME}/setup/services/cardano-db-sync.service > ${HOME}/setup/services/cardano-db-sync.tmp
sudo mv ${HOME}/setup/services/cardano-db-sync.tmp /lib/systemd/system/cardano-db-sync.service
sudo chmod 644 /lib/systemd/system/cardano-db-sync.service

echo -e "\n-= Create Block Producer Service =-"
envsubst < ${HOME}/setup/services/cardano-block-producer.service > ${HOME}/setup/services/cardano-block-producer.tmp
sudo mv ${HOME}/setup/services/cardano-block-producer.tmp /lib/systemd/system/cardano-block-producer.service
sudo chmod 644 /lib/systemd/system/cardano-block-producer.service

echo -e "\n-= Create Relay Service =-"
envsubst < ${HOME}/setup/services/cardano-relay.service > ${HOME}/setup/services/cardano-relay.tmp
sudo mv ${HOME}/setup/services/cardano-relay.tmp /lib/systemd/system/cardano-relay.service
sudo chmod 644 /lib/systemd/system/cardano-relay.service

echo -e "\n-= Create Prometheus-To-Cloudwatch Service =-"
envsubst < ${HOME}/setup/services/prometheus-to-cloudwatch.service > ${HOME}/setup/services/prometheus-to-cloudwatch.tmp
sudo mv ${HOME}/setup/services/prometheus-to-cloudwatch.tmp /lib/systemd/system/prometheus-to-cloudwatch.service
sudo chmod 644 /lib/systemd/system/prometheus-to-cloudwatch.service