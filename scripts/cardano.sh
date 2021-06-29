#!/bin/bash
set -e

echo -e "\n-= Download latest cardano binares from https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest/download/1 =-"
mkdir ${HOME}/setup/cardano -p
cd ${HOME}/setup/cardano
curl -L -o cardano.tar.gz https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest/download/1
tar -xvf cardano.tar.gz --directory ${NODE_HOME}/scripts --exclude configuration

echo -e "\n-= Download latest cardano-db-sync binares from https://hydra.iohk.io/job/Cardano/cardano-db-sync/cardano-db-sync-linux/latest/download/1 =-"
curl -L -o cardano-db-sync.tar.gz https://hydra.iohk.io/job/Cardano/cardano-db-sync/cardano-db-sync-linux/latest/download/1
tar -xvf cardano-db-sync.tar.gz --directory ${NODE_HOME}/scripts --exclude configuration

echo -e "\n-=Clone cardano-db-sync repository to get latest configuration and schema"
git clone https://github.com/input-output-hk/cardano-db-sync.git
cd cardano-db-sync
cp ./config/${NODE_CONFIG}-config.yaml ${NODE_HOME}/config/db-sync-${NODE_CONFIG}-config.yaml
cp ./schema/*.* ${NODE_HOME}/sync/schema

echo -e "\n-= Download Configuration Files =-"
NODE_BUILD_NUM=$(curl --silent https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g')
DOWNLOAD_URL=https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1

cd ${NODE_HOME}/config
curl -O ${DOWNLOAD_URL}/${NODE_CONFIG}-byron-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-topology.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-shelley-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-alonzo-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-config.json

echo -e "\n-= Rewriting ${NODE_CONFIG}-config.json =-"
jq ".defaultScribes += [[\"FileSK\"",\"${NODE_HOME}/logs/node/node\"]] ${NODE_CONFIG}-config.json | sponge ${NODE_CONFIG}-config.json
jq ".setupScribes += [{\"scFormat\":\"ScJson\", \"scKind\":\"FileSK\", \"scName\": \"${NODE_HOME}/logs/node/node\", \"scRotation\":null}]" ${NODE_CONFIG}-config.json | sponge ${NODE_CONFIG}-config.json
## Enable block fetch decisions if you want
# jq ".TraceBlockFetchDecisions = true" ${NODE_CONFIG}-config.json | sponge ${NODE_CONFIG}-config.json

echo -e "\n-= Rewriting db-sync-mainnet-config.yaml =-"
yq '.NodeConfigFile = "./mainnet-config.json"' db-sync-${NODE_CONFIG}-config.yaml -y | sponge db-sync-${NODE_CONFIG}-config.yaml
yq ".defaultScribes += [[\"FileSK\"",\"${NODE_HOME}/logs/sync/sync\"]] db-sync-${NODE_CONFIG}-config.yaml -y | sponge db-sync-${NODE_CONFIG}-config.yaml
yq ".setupScribes += [{\"scFormat\":\"ScJson\", \"scKind\":\"FileSK\", \"scName\": \"${NODE_HOME}/logs/sync/sync\", \"scRotation\":null}]" db-sync-${NODE_CONFIG}-config.yaml -y | sponge db-sync-${NODE_CONFIG}-config.yaml

echo -e "\n-= Create Relay Startup Script =-"
envsubst "NODE_HOME" < ${HOME}/setup/scripts/start-relay.sh > ${NODE_HOME}/scripts/start-relay.tmp
mv ${NODE_HOME}/scripts/start-relay.tmp ${NODE_HOME}/scripts/start-relay.sh
chmod +x ${NODE_HOME}/scripts/start-relay.sh

echo -e "\n-= Create Block Producer Startup Script =-"
envsubst "NODE_HOME" < ${HOME}/setup/scripts/start-block-producer.sh > ${NODE_HOME}/scripts/start-block-producer.tmp
mv ${NODE_HOME}/scripts/start-block-producer.tmp ${NODE_HOME}/scripts/start-block-producer.sh
chmod +x ${NODE_HOME}/scripts/start-block-producer.sh

echo -e "\n-= Create Db-Sync Startup Script =-"
envsubst "NODE_HOME" < ${HOME}/setup/scripts/start-db-sync.sh > ${NODE_HOME}/scripts/start-db-sync.tmp
mv ${NODE_HOME}/scripts/start-db-sync.tmp ${NODE_HOME}/scripts/start-db-sync.sh
chmod +x ${NODE_HOME}/scripts/start-db-sync.sh

echo -e "\n-= Symlinking scripts in ${NODE_HOME}/scripts/ =-"
sudo ln -sfL ${NODE_HOME}/scripts/* /usr/local/bin/

echo -e "\n-= Check Cardano is working =-"
cardano-cli version
cardano-node version