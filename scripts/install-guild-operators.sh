#!/bin/bash
set -e

echo "-= Download guild-operators scripts =-"
sudo mkdir ${CARDANO_USER_HOME}
sudo curl -sS -o ${CARDANO_USER_HOME}/prereqs.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/prereqs.sh
sudo chmod 755 ${CARDANO_USER_HOME}/prereqs.sh

echo "-= Running guild-operators setup script =-"
sudo ${CARDANO_USER_HOME}/prereqs.sh -l -c