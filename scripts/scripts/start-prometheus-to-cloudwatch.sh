#!/bin/bash
set -e

RAW_ID="$(ec2-metadata --instance-id)"
INSTANCE_ID="${RAW_ID##instance-id:}"

export CLOUDWATCH_NAMESPACE=cardano-metrics
export CLOUDWATCH_REGION=${TARGET_REGION}
export CLOUDWATCH_PUBLISH_TIMEOUT=5
export PROMETHEUS_SCRAPE_INTERVAL=30
export PROMETHEUS_SCRAPE_URL=http://localhost:12798/metrics
export ACCEPT_INVALID_CERT=true
export INCLUDE_METRICS=cardano_node_metrics_*
export ADDITIONAL_DIMENSION="InstanceId=${INSTANCE_ID}"
/usr/local/bin/prometheus-to-cloudwatch