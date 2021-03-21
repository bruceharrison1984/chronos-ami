# Cardano AMI
This repo contains a HashiCorp Packer template that can be used to build a Cardano node image. This can greatly speed up deployment in AWS, as well as
guarantee consistenct between nodes.

## Prerequsites
- Packer
- AWSCLI

## Usage
```sh
packer build . packer.pkr.hcl
```
This will begin the building process, and save the AMI to your AWS account when finished.

**AWS charges will be incurred during the build process**

We use a large instance size to speed up the build process, but it *should* result in charges less than $1. Keep an eye on the build process to make sure it doesn't run for a long period of time!
