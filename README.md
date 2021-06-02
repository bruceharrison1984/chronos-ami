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
packer build ./packer.pkr.hcl
```
This will begin the building process, and save the AMI to your AWS account when finished.

For help setting up Packer, see the offical documentation.

**AWS charges will be incurred during the build process**

We use a large instance size to speed up the build process, but it *should* result in charges less than $1. Keep an eye on the build process to make sure it doesn't run for a long period of time!

## Installed Items
- Latest Amazon Linux 2 OS
- Slected Cardano binaries are downloaded from IOHK Hydra
- Cloudwatch uses the latest pre-built version
  - Cloudwatch is preconfigured for logs

## AMI Configuration
- ENA Enabled
- EBS Optimized Enabled
- Drive Encryption Enabled (AWS Keys)

## Users
ec2-user is still used to login.

## Contribute
PRs are very welcome, as well as ADA donations:
- addr1qx2t4hr27795vwfpqffca6dzt9kfw77h362f0un0h2m8rsn0k2ukr28kxc4fzuxvrwf535zw78cc2p3er9hlnled9nsqhqc9uz
