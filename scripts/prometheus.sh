#!/usr/bin/bash
set -e

## Use Prometheus-To-Cloudwatch to pump prometheus metrics in to Cloudwatch
## The Cloudwatch Agent cannot process metrics that do not have type information
## https://github.com/cloudposse/prometheus-to-cloudwatch

# DOWNLOAD_URL="https://github.com/cloudposse/prometheus-to-cloudwatch/releases/download/0.14.0/prometheus-to-cloudwatch_linux_amd64"

# echo -e "\n-= Download Prometheus-To-Cloudwatch binares from ${DOWNLOAD_URL} =-"
# curl -L -o ${NODE_HOME}/scripts/prometheus-to-cloudwatch "${DOWNLOAD_URL}"
# chmod +x ${NODE_HOME}/scripts/prometheus-to-cloudwatch

# echo -e "\n-= Create Prometheus-To-Cloudwatch Startup Script =-"
# envsubst '${TARGET_REGION}' < ${HOME}/setup/scripts/start-prometheus-to-cloudwatch.sh > ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.tmp
# mv ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.tmp ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.sh
# chmod +x ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.sh

## This might not be needed if the prometheus metrics are correctly output with a schema