#!/bin/bash
set -e

. ~/.bashrc

echo -e "\n-= Create /cardano directory =-"
sudo mkdir /cardano/scripts -p

echo -e "\n-= Download latest binares from https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest/download/1 =-"
sudo mkdir ${HOME}/cardano
cd ${HOME}/cardano
sudo curl --silent -L -o cardano.tar.gz https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest/download/1
sudo tar -xvf cardano.tar.gz --directory ${NODE_HOME}/scripts --exclude configuration
sudo ln -sfL ${NODE_HOME}/scripts/* /usr/local/bin/
sudo rm -rf ${HOME}/cardano

echo -e "\n-= Check Cardano is working =-"
cardano-cli version
cardano-node version

echo -e "\n-= Download Configuration Files =-"
NODE_BUILD_NUM=$(curl --silent https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g')
DOWNLOAD_URL=https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1

cd ${NODE_HOME}
sudo curl --silent -O ${DOWNLOAD_URL}/${NODE_CONFIG}-byron-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-topology.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-shelley-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-config.json

# echo -e "\n Enable TraceBlockFetchDecisions"
# sed -i ${NODE_CONFIG}-config.json -e "s/TraceBlockFetchDecisions\": false/TraceBlockFetchDecisions\": true/g"

# echo -e "\n-= Create Startup Scripts =-"
# cat > $NODE_HOME/Start-Block-Producer.sh << EOF 
# #!/bin/bash
# DIRECTORY=$NODE_HOME
# PORT=6000
# HOSTADDR=0.0.0.0
# TOPOLOGY=\${DIRECTORY}/${NODE_CONFIG}-topology.json
# DB_PATH=\${DIRECTORY}/db
# SOCKET_PATH=\${DIRECTORY}/db/socket
# CONFIG=\${DIRECTORY}/${NODE_CONFIG}-config.json
# /usr/local/bin/cardano-node run --topology \${TOPOLOGY} --database-path \${DB_PATH} --socket-path \${SOCKET_PATH} --host-addr \${HOSTADDR} --port \${PORT} --config \${CONFIG}
# EOF
# chmod +x $NODE_HOME/Start-Block-Producer.sh

# cat > $NODE_HOME/Start-Relay.sh << EOF 
# #!/bin/bash
# DIRECTORY=$NODE_HOME
# PORT=6000
# HOSTADDR=0.0.0.0
# TOPOLOGY=\${DIRECTORY}/${NODE_CONFIG}-topology.json
# DB_PATH=\${DIRECTORY}/db
# SOCKET_PATH=\${DIRECTORY}/db/socket
# CONFIG=\${DIRECTORY}/${NODE_CONFIG}-config.json
# /usr/local/bin/cardano-node run --topology \${TOPOLOGY} --database-path \${DB_PATH} --socket-path \${SOCKET_PATH} --host-addr \${HOSTADDR} --port \${PORT} --config \${CONFIG}
# EOF