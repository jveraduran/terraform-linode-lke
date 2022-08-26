module "lke" {
  source        = "./modules/lke"
  region        = var.region
  nodes_count   = var.nodes_count
  k8s_version   = var.k8s_version
  label         = var.label
  tags          = var.tags
  conn_throttle = var.conn_throttle
  pools         = var.pools
}
module "bastion" {
  source   = "./modules/bastion"
  image_id = var.image_id
  region   = var.region
}