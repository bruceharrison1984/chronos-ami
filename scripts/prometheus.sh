#!/bin/bash
set -e

## Use Prometheus-To-Cloudwatch to pump prometheus metrics in to Cloudwatch
## The Cloudwatch Agent cannot process metrics that do not have type information
## https://github.com/cloudposse/prometheus-to-cloudwatch

DOWNLOAD_URL="https://github.com/cloudposse/prometheus-to-cloudwatch/releases/download/0.14.0/prometheus-to-cloudwatch_linux_amd64"

echo -e "\n-= Download Prometheus-To-Cloudwatch binares from ${DOWNLOAD_URL} =-"
curl -L -o ${NODE_HOME}/scripts/prometheus-to-cloudwatch "${DOWNLOAD_URL}"
chmod +x ${NODE_HOME}/scripts/prometheus-to-cloudwatch

echo -e "\n-= Create Prometheus-To-Cloudwatch Startup Script =-"
cat <<EOF > ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.sh
#!/bin/bash

RAW_ID=$(ec2-metadata --instance-id)
INSTANCE_ID=${RAW_ID##instance-id:}

export CLOUDWATCH_NAMESPACE=cardano-metrics
export CLOUDWATCH_REGION=${TARGET_REGION}
export CLOUDWATCH_PUBLISH_TIMEOUT=5
export PROMETHEUS_SCRAPE_INTERVAL=30
export PROMETHEUS_SCRAPE_URL=http://localhost:12798/metrics
export ACCEPT_INVALID_CERT=true
export INCLUDE_METRICS=cardano_node_metrics_*
export ADDITIONAL_DIMENSION="InstanceId=${INSTANCE_ID}"
/usr/local/bin/prometheus-to-cloudwatch
EOF
chmod +x ${NODE_HOME}/scripts/start-prometheus-to-cloudwatch.sh