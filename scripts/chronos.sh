#!/usr/bin/bash
set -e

RELEASE_FILENAME=chain-main_${NODE_VERSION}_Linux_arm64.tar.gz
RELEASE_URL=https://github.com/crypto-org-chain/chain-main/releases/download/v${NODE_VERSION}/${RELEASE_FILENAME}
NODE_LOCATION=${NODE_HOME}/node

echo -e "\n-= Start installing Chronos node to ${NODE_LOCATION} =-"
sudo curl -LOJ ${RELEASE_URL}
sudo tar -zxvf ${RELEASE_FILENAME} -C ${NODE_LOCATION}

echo -e "\n -= Check node version =-"
${NODE_LOCATION}/bin/chain-maind version