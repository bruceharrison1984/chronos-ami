variable "ami_name" {
  type    = string
  default = "red-hat-8"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "rhel8" {
  ami_name      = "packer example ${local.timestamp}"
  instance_type = "m5.xlarge"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "RHEL-8.*_HVM-*-x86_64-0-Hourly2-GP2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }
  ssh_username = "ec2-user"
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
      "~/setup_scripts/install-cloudwatch.sh",
      "sudo -i -u cardano -H sh -c ~/setup_scripts/install-guild-operators.sh",
      "sudo -i -u cardano -H sh -c ~/setup_scripts/install-cardano.sh"
    ]
    environment_vars = [
      "CARDANO_USER_HOME=/home/cardano/tmp"
    ]
  }
}

