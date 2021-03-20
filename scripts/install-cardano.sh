#!/bin/bash
set -e

echo "-= Cloning Cardano Git repository =-"
cd ~/git
git clone https://github.com/input-output-hk/cardano-node
cd cardano-node

echo "-= Checkout latest version =-"
git fetch --tags --all
git pull
git checkout $(curl -s https://api.github.com/repos/input-output-hk/cardano-node/releases/latest | jq -r .tag_name)

echo "-= Build Cardano binaries =-"
# The "-o" flag against script below will download cabal.project.local to depend on system libSodium package, and include cardano-address and bech32 binaries to your build
$CNODE_HOME/scripts/cabal-build-all.sh -o

echo "-= Check Cardano is working =-"
cardano-cli version
cardano-node version

### these need to be set to something https://cardano-community.github.io/guild-operators/#/Build/node-cli
# CNODE_PORT=6000
# POOL_NAME="GUILD"