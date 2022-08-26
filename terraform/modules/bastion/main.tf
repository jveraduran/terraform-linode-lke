resource "linode_instance" "bastion" {
  label  = "bastion"
  image  = data.linode_image.bastion.id
  region = var.region
  type   = "g6-standard-1"

  group      = "foo"
  tags       = ["foo"]
  swap_size  = 256
  private_ip = true
}