variable "linode_token" {
  type    = string
  default = env("LINODE_TOKEN")
}

variable "version" {
  type    = string
  default = env("VERSION")
}

locals {
  image             = "linode/ubuntu18.04"
  image_description = "Bastion Private Image"
  image_label       = "bastion"
  instance_label    = "bastion"
  instance_type     = "g6-standard-1"
  region            = "us-east"
  ssh_username      = "root"
}

source "linode" "bastion" {
  image             = local.image
  image_description = local.image_description
  image_label       = local.image_label
  instance_label    = local.instance_label
  instance_type     = local.instance_type
  linode_token      = var.linode_token
  region            = local.region
  ssh_username      = local.ssh_username
}

build {
  sources = ["source.linode.bastion"]

  provisioner "shell" {
    inline = [
      "sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y"
    ]
  }
  provisioner "shell" {
    inline = [
      "mkdir ~/ssh-conf",
      "sudo apt-get update -y",
      "sudo apt-get install -y zsh unzip jq python3 python3-pip",
      "sudo pip3 install linode-cli --upgrade",
      "sudo pip3 install boto",
      "wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh",
      "chmod +x ./install.sh",
      "sudo ./install.sh",
      "sudo chsh -s /bin/zsh $(whoami)",
      "sudo chown $(whoami):$(whoami) .oh-my-zsh .zshrc",
      "sed s/robbyrussell/bira/g -i .zshrc",
      "rm -f install.sh",
      "git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions",
      "echo \"source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh\" >> ~/.zshrc"
    ]
  }

  provisioner "shell" {
    inline = [
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "sudo touch /etc/apt/sources.list.d/kubernetes.list",
      "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt update",
      "sudo apt install -y kubectl",
      "wget https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz -O helm.tar.gz",
      "tar zxfv helm.tar.gz",
      "sudo mv linux-amd64/helm /usr/local/bin",
      "rm -f helm.tar.gz",
      "rm -rf linux-amd64",
      "echo \"source <(kubectl completion zsh)\" >> ~/.zshrc"
    ]
  }

  provisioner "file" {
    source      = "./packer/ssh/ssh_config"
    destination = "~/ssh-conf/ssh_config"
  }

  provisioner "file" {
    source      = "./packer/ssh/trusted-user-ca-keys.pem"
    destination = "~/ssh-conf/trusted-user-ca-keys.pem"
  }

  provisioner "file" {
    source      = "./packer/ssh/sshd_config"
    destination = "~/ssh-conf/sshd_config"
  }

  provisioner "file" {
    source      = "./packer/ssh/config"
    destination = "~/ssh-conf/config"
  }

  provisioner "shell" {
    inline = [
      "sudo cp ~/ssh-conf/sshd_config /etc/ssh/",
      "sudo cp ~/ssh-conf/ssh_config /etc/ssh/",
      "sudo cp ~/ssh-conf/trusted-user-ca-keys.pem /etc/ssh/",
      "sudo cp ~/ssh-conf/config ~/.ssh/config",
      "rm -rf ~/ssh-conf"
    ]
  }
}

