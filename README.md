**This is an experimental project, use at your own risk!**

# Cardano AMI
This repo contains a HashiCorp Packer template that can be used to build a Cardano node image. This can greatly speed up deployment in AWS, as well as
guarantee consistency between nodes.

The finished image is placed in your personal AWS AMI respoitory, so you can feel safe knowing where it came from.

## Prerequsites
- Packer
- AWSCLI
- Default VPC in AWS
  - Not having a default VPC will prevent the build instance from launching

## Usage
```sh
packer build . packer.pkr.hcl
```
This will begin the building process, and save the AMI to your AWS account when finished.

For help setting up Packer, see the offical documentation.

**AWS charges will be incurred during the build process**

We use a large instance size to speed up the build process, but it *should* result in charges less than $1. Keep an eye on the build process to make sure it doesn't run for a long period of time!

## Installed Items
- RHEL Linux 8 is used as the OS
- All Cardano items are built from latest available sources
  - Offical cardano-node and cardano-cli executables
  - Guild Operators scripts
  - Cloudwatch Logging/Monitoring
- Cloudwatch uses the latest pre-built version

## Users
ec2-user is still used to login, and all Cardano items are installed under the `cardano` user. The `cardano` user still has `sudo` privileges upon boot, so if you do not want this be sure to remove it. It is intentionally left in since this image is primarily for fast testing.
