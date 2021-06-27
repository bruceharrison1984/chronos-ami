#!/bin/bash
set -e

## Use Prometheus-To-Cloudwatch to pump prometheus metrics in to Cloudwatch
## The Cloudwatch Agent cannot process metrics that do not have type information
## https://github.com/cloudposse/prometheus-to-cloudwatch

DOWNLOAD_URL="https://github.com/cloudposse/prometheus-to-cloudwatch/releases/download/0.14.0/prometheus-to-cloudwatch_linux_amd64"

echo -e "\n-= Download Prometheus-To-Cloudwatch binares from ${DOWNLOAD_URL} =-"
sudo curl --silent -L -o ${NODE_HOME}/scripts/prometheus-to-cloudwatch "${DOWNLOAD_URL}"
sudo chmod +x ${NODE_HOME}/scripts/prometheus-to-cloudwatch

echo -e "\n-= Create Prometheus-To-Cloudwatch Startup Script =-"
sudo cat <<EOF >> ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.sh
#!/bin/bash

export CLOUDWATCH_NAMESPACE=cardano-db-sync-metrics
export CLOUDWATCH_REGION=us-east-1
export CLOUDWATCH_PUBLISH_TIMEOUT=5
export PROMETHEUS_SCRAPE_INTERVAL=30
export PROMETHEUS_SCRAPE_URL=http://localhost:12789/metrics
export ACCEPT_INVALID_CERT=true

${NODE_HOME}/scripts/prometheus-to-cloudwatch
EOF
sudo chmod +x ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.sh