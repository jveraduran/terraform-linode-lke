packer {
  required_plugins {
    linode = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/linode"
    }
  }
}