#!/bin/bash
set -e

echo "-= Download guild-operators scripts =-"
sudo mkdir /setup_scripts/downloads
sudo curl -sS -o /setup_scripts/downloads/prereqs.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/prereqs.sh
sudo chmod 755 /setup_scripts/downloads/prereqs.sh

echo "-= Running guild-operators setup script =-"
/setup_scripts/downloads/prereqs.sh -l -c