#!/usr/bin/bash
set -e

## we use envsubst as non-sudo because the proper envvars are already loaded in the ec2-user profile
## this hard-codes the service user to the ${USERNAME} variable

echo -e "\n-= Create Chronos Sentry service =-"
envsubst < ${HOME}/setup/services/chronos-sentry.service > ${HOME}/setup/services/chronos-sentry.tmp
sudo mv ${HOME}/setup/services/chronos-sentry.tmp /lib/systemd/system/chronos-sentry.service
sudo chmod 644 /lib/systemd/system/chronos-sentry.service
