#!/usr/bin/bash
set -e

NODE_LOCATION=${NODE_HOME}/node

echo -e "\n-= Start installing Chronos node to ${NODE_LOCATION} =-"
sudo curl -LOJ https://github.com/crypto-org-chain/chain-main/releases/download/v${NODE_VERSION}/chain-main_${NODE_VERSION}_Linux_x86_64.tar.gz
sudo tar -zxvf chain-main_${NODE_VERSION}_Linux_x86_64.tar.gz -C ${NODE_LOCATION}

echo -e "\n -= Check node version =-"
${NODE_LOCATION}/bin/chain-maind version