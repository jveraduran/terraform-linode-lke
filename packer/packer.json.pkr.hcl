variable "linode_token" {
  type    = string
  default = env("LINODE_TOKEN")
}

variable "version" {
  type    = string
  default = env("VERSION")
}

locals {
  image             = "linode/ubuntu22.04"
  image_description = "Bastion Private Image"
  image_label       = "bastion"
  instance_label    = "bastion"
  instance_type     = "g6-standard-1"
  region            = "us-east"
  ssh_username      = "root"
  authorized_keys   = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC14w4MzeV/v1qrKLtxD7XeLIIGzrPdYj1poYxtgyjiqco5u4Lh9oiYuz2m7qGQW+ZqBdZIvmP+msGorD8fM+tWQSZuk4PxLGEDoRJ1+cEVLjanNPDEm68vgK18lyKr1lPkyM64R3TssoCy26NbOrU/pdM9txVx9o0pynypx2lFsUYrnE+LEM8kmpJjdFZvh0onHC17io5y/aZcw6q+e0xcs2J390sjtUcBJ0GB6lUmlEwB6Y2pRPMPJdDTF1gxSmZFEVl1EIlAQTHtYQmKc8D55AU8Gbe4AoWIIeh5Ei8HQfj+HxkOVX5jxcHtTpan/O61vg66FFJShZiQrZ+CbcGx"]
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
  authorized_keys   = local.authorized_keys
}

build {
  sources = ["source.linode.bastion"]
  
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
      "curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
      "curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256\"",
      "echo \"$(cat kubectl.sha256) kubectl\" | sha256sum --check",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
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
      "sudo cp ~/ssh-conf/config .ssh/config",
      "rm -rf ~/ssh-conf"
    ]
  }
}

