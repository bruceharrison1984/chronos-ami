#!/bin/bash
set -e

. ~/.profile

export DOWNLOAD_URL=https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1
export FILENAME=cardano-node-${NODE_VERSION}-linux.tar.gz

echo -e "\n-= Create /cardano directory =-"
sudo mkdir /cardano/scripts -p

echo -e "\n-= Download binares from ${DOWNLOAD_URL} =-"
sudo mkdir ${HOME}/cardano
cd ${HOME}/cardano
sudo curl --silent -O ${DOWNLOAD_URL}/${FILENAME}
sudo tar -xvf ${FILENAME} --directory ${NODE_HOME}/scripts
sudo ln -sfL ${NODE_HOME}/scripts/* /usr/local/bin/
sudo rm -rf ${HOME}/cardano

echo -e "\n-= Download Configuration Files =-"
cd ${NODE_HOME}
sudo curl --silent -O ${DOWNLOAD_URL}/${NODE_CONFIG}-byron-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-topology.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-shelley-genesis.json \
  -O ${DOWNLOAD_URL}/${NODE_CONFIG}-config.json

echo -e "\n-= Check Cardano is working =-"
cardano-cli version
cardano-node version