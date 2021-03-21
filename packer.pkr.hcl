locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "rhel8" {
  ami_name        = "cardano-node-${local.timestamp}"
  ami_description = "Provisioned AMI for running a Cardano cluster"
  instance_type   = "m5.4xlarge"
  region          = "us-east-1"
  ena_support     = true
  ssh_username    = "ec2-user"
  encrypt_boot    = true
  ebs_optimized   = true

  source_ami_filter {
    filters = {
      name                = "RHEL-8.*_HVM-*-x86_64-0-Hourly2-GP2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }

  tags = {
    Name         = "cardano-node-${local.timestamp}"
    CreatedOn    = timestamp()
    ENA          = true
    EBSOptimized = true
    Encrypted    = true
  }
}

build {
  sources = ["source.amazon-ebs.rhel8"]
  provisioner "shell" {
    inline = ["mkdir /home/ec2-user/setup_scripts/"]
  }
  provisioner "file" {
    destination = "/home/ec2-user/setup_scripts/"
    source      = "./scripts/"
  }
  provisioner "shell" {
    inline = [
      "chmod -R +x ~/setup_scripts/*.sh",
      "~/setup_scripts/init.sh",
      "sudo -i -u cardano -H sh -c '/setup_scripts/install-guild-operators.sh'",
      "sudo -i -u cardano -H sh -c '/setup_scripts/install-cardano.sh'"
    ]
    environment_vars = [
      "CARDANO_USER_HOME=/home/cardano/tmp"
    ]
  }
}
