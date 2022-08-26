data "linode_images" "bastion" {
  filter {
    name = "label"
    values = ["private-image"]
  }
}