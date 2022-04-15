**This is an experimental project, use at your own risk!**

# Chronos AMI

This repo contains a HashiCorp Packer template that can be used to build a chronos node image. This can greatly speed up deployment in AWS, as well as
guarantee consistency between nodes.

## Prerequsites

- Packer
- AWSCLI
- Default VPC in AWS
  - Not having a default VPC will prevent the build instance from launching
- Must run as a t3.\* instace type due to ENI being enabled

## Usage

```sh
packer build ./packer.pkr.hcl
```

This will begin the building process, and save the AMI to your AWS account when finished.

For help setting up Packer, see the offical documentation.

**AWS charges will be incurred during the build process**

## Installed Items

- Latest Amazon Linux 2 OS
- Latest chronos binaries are downloaded from IOHK Hydra
- Cloudwatch uses the latest pre-built version
  - Cloudwatch is preconfigured for logs
- Google Authenticator installed
  - Must be configured
- Fail2Ban installed
  - 10 minute ban
  - Can easily be changed by altering `/etc/fail2ban/jail.d/sshd.local`
- Prometheus-To-Cloudwatch
  - Allows sending Prometheus metrics in to Cloudwatch without a Prometheus server

## AMI Configuration

- ENA Enabled
- EBS Optimized Enabled
- Drive Encryption Enabled (AWS Keys)

## Users

- ec2-user is used to login with private key
  - This can be altered via UserData/CloudInit scripts when you launch the image
- `chronos` user is the owner of the /chronos
  - systemd services are configured to run under the `chronos` user
- Cloudwatch runs under the `cwagent` user,
  - `cwagent` has `adm` permissions

## Services

Four services are available to run depending on your use case. **Both services should never be running at the same time.**

- cardano-block-producer.service
  - Start this service to make the node a block-producer
  - Keys must be in /cardano/keys prior to starting
- cardano-relay.service
  - Start this service to make the node a relay
- prometheus-to-cloudwatch
  - Start this to begin sending Prometheus metrics to Cloudwatch
    - IAM permissions must be granted in order to post metrics
- cardano-db-sync
  - Begin writing the chain in to a PostGres database
    - `\${NODE_HOME}/config/pgpass-mainnet` must have a valid connection string

To configure these services to run at start-up, run one of the following:

```sh
sudo systemctl enable cardano-block-producer.service
##or
sudo systemctl enable cardano-relay.service
```

## Usage

This image can be used as is, with manual configuration changes made to get it up and running. UserData/CloudInit could also be used to automate
the configuration of the server once it comes up as well.

This includes but isn't limited to:

- Disable ec2-user account & create new login user
- Start the node as a relay/block-producer
- Setup auto-rotate SSH keys via Lambda
- Load Keys from a secure S3 bucket

## Logging

Plain text logs are sent to journalctl based on service name. File-based Cardano JSON logs are saved to `/cardano/logs`, which are generally more useful for log
aggregation. File-based logs are auto-rotated by cardano-node.

### Cloudwatch

By default, any important log files are automatically sent to Cloudwatch. See `config/amazon-cloudwatch-agent.json` if you wish to change this.

### Prometheus Metrics

All prometheus metrics are sent to Cloudwatch via Prometheus-To-Cloudwatch.

### IAM Permissions

In order for logs and metrics to post to Cloudwatch, proper IAM permissions must be applied to the EC2 instance. This can easily be applied by attaching the `CloudWatchAgentServerPolicy` to a Role, and attaching that role as the EC2 instance profile.

## Db-Sync

DB Sync is included and has a prebuilt unit file to run it as a service. You must alter the PGPASS file with the correct connection string
in `${NODE_HOME}/config/pgpass-mainnet` before starting the service. By default, the service depends on `cardano-relay` to already be running,
and is not intended to be ran on a block producer.

Db-Sync will auto-provision the tables needed, but the underlying database must already exist before starting the service. If the database doesn't exist,
then the service will fail to start.

## Contribute

PRs are very welcome, as well as ADA donations:

- addr1qx2t4hr27795vwfpqffca6dzt9kfw77h362f0un0h2m8rsn0k2ukr28kxc4fzuxvrwf535zw78cc2p3er9hlnled9nsqhqc9uz
