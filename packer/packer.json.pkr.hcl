variable "linode_token" {
  type    = string
  default = env("LINODE_TOKEN")
}

locals {
  image             = "linode/ubuntu18.04"
  image_description = "My Private Image"
  image_label       = "private-image"
  instance_label    = "temporary-linode"
  instance_type     = "g6-standard-1"
  region = "us-east"
  ssh_username = "root"
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
}