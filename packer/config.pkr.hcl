packer {
  required_plugins {
    linode = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/linode"
    }
  }
}