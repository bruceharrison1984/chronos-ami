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

echo -e "\n-= Create Sentry Init Script =-"
envsubst '${NODE_HOME}' < ${HOME}/setup/scripts/init-sentry.sh > ${HOME}/setup/scripts/init-sentry.tmp
mv ${HOME}/setup/scripts/init-sentry.tmp ${NODE_HOME}/scripts/init-sentry.sh
cat ${NODE_HOME}/scripts/init-sentry.sh

echo -e "\n-= Create Sentry Start Script =-"
envsubst '${NODE_HOME}' < ${HOME}/setup/scripts/start-sentry.sh > ${HOME}/setup/scripts/start-sentry.tmp
mv ${HOME}/setup/scripts/start-sentry.tmp ${NODE_HOME}/scripts/start-sentry.sh

echo -e "\n-= Create QuickSync Script =-"
mv ${HOME}/setup/scripts/download-quicksync.sh ${NODE_HOME}/scripts/download-quicksync.sh

echo -e "\n-= Set ${NODE_HOME}/scripts/*.sh as executable =-"
chmod -R +x ${NODE_HOME}/scripts/*.sh

echo -e "\n-= Symlinking scripts in ${NODE_HOME}/scripts/ =-"
sudo ln -sfL ${NODE_HOME}/scripts/* /usr/local/bin/