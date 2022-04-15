#!/usr/bin/bash
set -e

echo -e "\n-= Start installing Chronos node =-"
curl -LOJ https://github.com/crypto-org-chain/chain-main/releases/download/v${NODE_VERSION}/chain-main_${NODE_VERSION}_Linux_x86_64.tar.gz\
tar -zxvf chain-main_${NODE_VERSION}_Linux_x86_64.tar.gz