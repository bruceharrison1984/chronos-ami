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

# The "-o" flag against script below will download cabal.project.local to depend on system libSodium package, and include cardano-address and bech32 binaries to your build
$CNODE_HOME/scripts/cabal-build-all.sh -o