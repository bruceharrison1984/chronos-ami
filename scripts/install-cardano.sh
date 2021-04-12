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
cat <<EOF > cabal.project.local
package cardano-crypto-praos
flags: -external-libsodium-vrf
EOF
$CNODE_HOME/scripts/cabal-build-all.sh -o

echo "-= Check Cardano is working =-"
cardano-cli version
cardano-node version