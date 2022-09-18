module "lke" {
  source               = "./modules/lke"
  region               = var.region
  nodes_count          = 1
  k8s_version          = var.k8s_version
  label                = var.label
  tags                 = var.tags
  client_conn_throttle = var.client_conn_throttle
  pool                 = var.pool
}

resource "local_file" "kubeconfig" {
  depends_on = [
    module.lke
  ]
  content  = base64decode(module.lke.kubeconfig)
  filename = "cluster.yaml"
}

module "bastion" {
  source          = "./modules/bastion"
  image_id        = data.linode_images.bastion.images[0].id
  authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCDq8DLYtJRElRE12PEz2hOe4jRo+e9tarnuBeTMdSt3WICOB7HAZLFgJzvxAyNBI2JgbLdgstEt6Ocuz9LGeyvFQX6WgmI7xPE4ixeYa+s2sgWM7ahAtrdlW75HzE2Z0U6SJDT5PCTXP7yViGbHOEBaNUkaHO52l0RCdkB6UP5vJqLkrUGg4cbvjlQRKFg6inKEXVH8546jA8OG/OGXdsPcUPN5JEdoKorNTRoED8c4mNRhMVjb4dDLT+x7PjvVyuhF9LWwjHpcj5sELFT9wyRkcURtcGjtFlbYdCjc0DPkohOilVtUzZEo/+vuFL8NTSpUgkYq7oDqKHRjdCDqeMk1bHUZSI5R6e5lLrpj30QNVDVpyIpv3hgsZMvuwjE+dky0yyXw3xsal0zE0Rk/A34CuZCVnQHahkDWg7Ap9WP1UYngelixHED13g5K42zpGSfO+3oot7qQPMx2slx7bC7Pym4+GM+XfPIfRvznwJlsmUY1vDYb6a2dkv8jo7121XyU7hIy7dfKr/4DBXiAw9xHARSNviPvphoxn7q+j69ZLMo2sinOzDZqRpi+kSdP7nMi4NuYutRTPJ7/Z2ffEOYmYRNEaFcVviv3n70b1BuLoeOOy0l68OuN2DYai2AjbgLC5RzeW321+EJmhxb9m8PT4zrFKdvZrdZFpAQiDHCQ=="]
  region          = var.region
  type            = "g6-standard-1"
  label           = "bastion"
  swap_size       = 256
  tags            = var.tags
  private_ip      = true
  booted          = true
}

resource "null_resource" "bastion" {
  depends_on = [
    module.lke, local_file.kubeconfig, module.bastion
  ]
  provisioner "remote-exec" {
    inline = ["mkdir .kube"]
    connection {
      host        = module.bastion.ip_address
      type        = "ssh"
      user        = "root"
      private_key = file("./id_rsa")
    }
  }
  provisioner "file" {
    source      = "./cluster.yaml"
    destination = ".kube/config"

    connection {
      host        = module.bastion.ip_address
      type        = "ssh"
      user        = "root"
      private_key = file("./id_rsa")
    }
  }
}

module "kubernetes_addons" {
  depends_on = [
    module.lke, module.bastion, null_resource.bastion
  ]
  source              = "./modules/kubernetes-addons"
  enable_external_dns = true
}