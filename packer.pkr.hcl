variable "username" {
  type = string
  default = "chronos"
}

variable "node_version" {
  type = string
  default = "1.2.1"
}

variable "target_region" {
  type = string
  default = "us-east-1"
}

locals { 
  timestamp = regex_replace(timestamp(), "[T:]", "-")
}

source "amazon-ebs" "aws_linux" {
  ami_name        = "chronos-sentry-${var.node_version}-${local.timestamp}"
  ami_description = "Provisioned AMI for running a Chronos Sentry"
  instance_type   = "a1.large"
  region          = "${var.target_region}"
  ena_support     = true
  ssh_username    = "ec2-user"
  encrypt_boot    = true
  ebs_optimized   = true

  ami_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 100
    encrypted = true
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 100
    encrypted = true
    delete_on_termination = true
  }
  
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-*-arm64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }

  ## temporary instance profile required to initialize cloudwatch-agent prometheus metrics
  temporary_iam_instance_profile_policy_document {
    Statement {
      Effect = "Allow"
      Action = ["ec2:DescribeTags"]
      Resource = ["*"]
    }
    Version = "2012-10-17"
  }

  tags = {
    Name         = "chronos-sentry-${local.timestamp}"
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
      "NODE_HOME=/chronos",
      "NODE_VERSION=${var.node_version}",
      "USERNAME=${var.username}",
      "TARGET_REGION=${var.target_region}"
    ]
    inline = [
      "chmod -R +x /home/ec2-user/setup/*.sh",
      "/home/ec2-user/setup/init.sh",
      "/home/ec2-user/setup/cloudwatch.sh",
      "/home/ec2-user/setup/prometheus.sh",
      "/home/ec2-user/setup/chronos.sh",
      "/home/ec2-user/setup/services.sh",
      "/home/ec2-user/setup/extras.sh",
      "/home/ec2-user/setup/clean-up.sh",
    ]
  }
}
