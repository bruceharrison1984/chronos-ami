variable "node_config" {
  type = string
  default = "mainnet"
}

variable "node_home" {
  type = string
  default = "/cardano"
}

variable "username" {
  type = string
  default = "cardano"
}

locals { timestamp = regex_replace(timestamp(), "[T:]", "-") }

source "amazon-ebs" "aws_linux" {
  ami_name        = "cardano-node-${local.timestamp}"
  ami_description = "Provisioned AMI for running a Cardano cluster"
  instance_type   = "m5.xlarge"
  region          = "us-east-1"
  ena_support     = true
  ssh_username    = "ec2-user"
  encrypt_boot    = true
  ebs_optimized   = true

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 100
    encrypted = true
    delete_on_termination = true
  }
  
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
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
  sources = ["source.amazon-ebs.aws_linux"]
  provisioner "shell" {
    inline = ["mkdir /home/ec2-user/setup/"]
  }
  provisioner "file" {
    destination = "/home/ec2-user/setup/"
    source      = "./scripts/"
  }
  provisioner "shell" {
    environment_vars = [
      "NODE_CONFIG=${var.node_config}",
      "NODE_HOME=${var.node_home}",
      "USERNAME=${var.username}",
    ]
    inline = [
      "chmod -R +x /home/ec2-user/setup/*.sh",
      "/home/ec2-user/setup/init.sh",
      "/home/ec2-user/setup/cardano.sh",
      "/home/ec2-user/setup/services.sh",
      "/home/ec2-user/setup/extras.sh",
      "rm -rf /home/ec2-user/setup",
    ]
  }
}
