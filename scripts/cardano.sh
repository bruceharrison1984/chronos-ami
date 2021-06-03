#!/bin/bash
set -e

. ~/.bashrc

echo -e "\n-= Create /cardano directory =-"
sudo mkdir /cardano/scripts -p
sudo mkdir /cardano/keys -p
sudo mkdir /cardano/config -p

echo -e "\n-= Download latest binares from https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest/download/1 =-"
sudo mkdir ${HOME}/cardano
cd ${HOME}/cardano
sudo curl --silent -L -o cardano.tar.gz https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest/download/1
sudo tar -xvf cardano.tar.gz --directory ${NODE_HOME}/scripts --exclude configuration
sudo rm -rf ${HOME}/cardano



echo -e "\n-= Check Cardano is working =-"
cardano-cli version
cardano-node version

echo -e "\n-= Download Configuration Files =-"
NODE_BUILD_NUM=$(curl --silent https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g')
DOWNLOAD_URL=https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1

cd ${NODE_HOME}/config
sudo curl --silent -O ${DOWNLOAD_URL}/${NODE_CONFIG}-byron-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-topology.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-shelley-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-alonzo-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-config.json

echo -e "\n Enable TraceBlockFetchDecisions"
sudo sed -i ${NODE_HOME}/config/${NODE_CONFIG}-config.json -e "s/TraceBlockFetchDecisions\": false/TraceBlockFetchDecisions\": true/g"

echo -e "\n-= Create Relay Startup Script =-"
cat <<EOF >> ${NODE_HOME}/scripts/start-relay.sh
#!/bin/bash

/usr/local/bin/cardano-node run \
  --topology ${NODE_HOME}/config/${NODE_CONFIG}-topology.json \
  --database-path ${CARDANO_DB_PATH} \
  --socket-path ${CARDANO_NODE_SOCKET_PATH} \
  --host-addr 0.0.0.0 \
  --port ${NODE_PORT} \
  --config ${NODE_HOME}/config/${NODE_CONFIG}-config.json
EOF
chmod +x $NODE_HOME/scripts/start-relay.sh

echo -e "\n-= Create Block Producer Startup Script =-"
cat <<EOF >> ${NODE_HOME}/scripts/start-block-producer.sh
#!/bin/bash

/usr/local/bin/cardano-node run \
  --topology ${NODE_HOME}/config/${NODE_CONFIG}-topology.json \
  --database-path ${CARDANO_DB_PATH} \
  --socket-path ${CARDANO_NODE_SOCKET_PATH} \
  --host-addr 0.0.0.0 \
  --port ${NODE_PORT} \
  --config ${NODE_HOME}/config/${NODE_CONFIG}-config.json
  --shelley-kes-key ${NODE_HOME}/keys/kes.skey \
  --shelley-vrf-key ${NODE_HOME}/keys/vrf.skey \
  --shelley-operational-certificate ${NODE_HOME}/keys/node.cert
EOF
chmod +x $NODE_HOME/scripts/start-block-producer.sh

echo -e "\n-= Symlinking scripts in ${NODE_HOME}/scripts/ =-"
sudo ln -sfL ${NODE_HOME}/scripts/* /usr/local/bin/