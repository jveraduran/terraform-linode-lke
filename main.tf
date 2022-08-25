resource "linode_lke_cluster" "awesome_cluster" {
  k8s_version = var.k8s_version
  label       = var.label
  region      = var.region
  tags        = var.tags

  dynamic "pool" {
    for_each = var.pools
    content {
      type  = pool.value["type"]
      count = pool.value["count"]
    }
  }
}

resource "linode_nodebalancer" "awesome_cluster_lb" {
  label                = var.label
  region               = var.region
  tags                 = var.tags
  client_conn_throttle = var.conn_throttle
}

resource "linode_nodebalancer_config" "awesome_cluster_lb_config" {
  nodebalancer_id = linode_nodebalancer.awesome_cluster_lb.id
  port            = 443
  protocol        = "http"
  check           = "http"
  check_path      = "/ping"
  check_attempts  = 3
  check_timeout   = 5
  check_interval  = 30
  algorithm       = "source"
}

resource "linode_nodebalancer_node" "awesome_cluster_lb_node" {
  count           = var.nodes_count
  nodebalancer_id = linode_nodebalancer.awesome_cluster_lb.id
  config_id       = linode_nodebalancer_config.awesome_cluster_lb_config.id
  address         = "${element(local.lke_node_ips, count.index)}:80"
  label           = var.label
  weight          = 50
}



//Export this cluster's attributes
output "kubeconfig" {
  value     = linode_lke_cluster.awesome_cluster.kubeconfig
  sensitive = true
}
