module "lke" {
  source               = "./modules/lke"
  region               = var.region
  nodes_count          = var.nodes_count
  k8s_version          = var.k8s_version
  label                = var.label
  tags                 = var.tags
  client_conn_throttle = var.client_conn_throttle
  pool                 = var.pool
}
module "bastion" {
  source     = "./modules/bastion"
  image_id   = "private/17160586"
  region     = var.region
  type       = "g6-standard-1"
  label      = "temporary-linode"
  swap_size  = 256
  tags       = var.tags
  private_ip = true
}