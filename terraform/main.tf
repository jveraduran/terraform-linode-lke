module "lke" {
  source               = "./modules/lke"
  region               = var.region
  nodes_count          = 3
  k8s_version          = var.k8s_version
  label                = var.label
  tags                 = var.tags
  client_conn_throttle = var.client_conn_throttle
  pool                 = var.pool
}
module "bastion" {
  source          = "./modules/bastion"
  image_id        = data.linode_images.bastion.images[0].id
  authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC10SXNDdjglIB8hLveI12aZty0Fo5ZkVphuw9HAi4jYX7vUnGQGRGbBaOQQrv926ZP8tY91/3SPxW1p0qY6GToPkk/CW0oyOjgvztHb3rAxAWofSDMYuesEaqbOWVqSep3HTV1WqRrw+Qta7TfQCoG+OemZHljHW+z7zPnqyUQifFKvfgkc7RB3ywAlcixYAXqlfm4zRlDlhHrkQabxWiGTQsc7wM5K8qN912CheC0KU2TyVSGkq0ClkSMyIC6IDCJxSuqcoKZ2fKxcyEvwsGZmiJHQbt/3I9Ix6KlsuP8k3lg4Ic8ixgzEx8mXiKmc9EjzhSF+/kaOp7yPmRekfRanJ0yS5YgKqxGF6XDTpCNJZoyk0cNrWHiS/97Oj/61pYPnQH/fgJ4ZU4LYBK8UiqL2tRUw7JRlOZnwtYJttw8j1OiJhStLMwjvZhBflD+KMA9D0r+5Advm8/HK3IiK863Ss0dUMCBOH14zuEIF7fzAhs3UZk9olikmq7uq7UCm20="]
  region          = var.region
  type            = "g6-standard-1"
  label           = "bastion"
  swap_size       = 256
  tags            = var.tags
  private_ip      = true
  booted          = true
}

resource "local_file" "kubeconfig" {
  content  = base64decode(module.lke.kubeconfig)
  filename = "cluster.yaml"
}