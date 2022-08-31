resource "linode_lke_cluster" "awesome_cluster" {
  # Required
  label       = var.label
  k8s_version = var.k8s_version
  region      = var.region
  dynamic "pool" {
    for_each = var.pool
    content {
      type  = pool.value["type"]
      count = pool.value["count"]
      dynamic "autoscaler" {
        for_each = var.autoscaler != null ? [var.autoscaler] : []
        content {
          min = lookup(pool.autoscaler, "min", null)
          max = lookup(pool.autoscaler, "max", null)
        }
      }
    }
  }
  # Optional
  tags = var.tags == "" ? null : var.tags
  dynamic "control_plane" {
    for_each = var.control_plane != null ? [var.control_plane] : []
    content {
      high_availability = lookup(pool.control_plane, "high_availability", null)
    }
  }
}

resource "linode_nodebalancer" "awesome_cluster_lb" {
  # Required
  region = var.region
  # Optional
  label                = var.label == "" ? null : var.label
  tags                 = var.tags == "" ? null : var.tags
  client_conn_throttle = var.client_conn_throttle == "" ? null : var.client_conn_throttle
}

resource "linode_nodebalancer_config" "awesome_cluster_lb_config" {
  # Required
  nodebalancer_id = linode_nodebalancer.awesome_cluster_lb.id
  # Optional
  protocol       = var.protocol == "" ? null : var.protocol
  proxy_protocol = var.proxy_protocol == "" ? null : var.proxy_protocol
  port           = var.port == "" ? null : var.port
  algorithm      = var.algorithm == "" ? null : var.algorithm
  stickiness     = var.stickiness == "" ? null : var.stickiness
  check          = var.check == "" ? null : var.check
  check_interval = var.check_interval == "" ? null : var.check_interval
  check_timeout  = var.check_timeout == "" ? null : var.check_timeout
  check_attempts = var.check_attempts == "" ? null : var.check_attempts
  check_path     = var.check_path == "" ? null : var.check_path
  check_passive  = var.check_passive == "" ? null : var.check_passive
  cipher_suite   = var.cipher_suite == "" ? null : var.cipher_suite
  ssl_cert       = var.ssl_cert == "" ? null : var.ssl_cert
  ssl_key        = var.ssl_key == "" ? null : var.ssl_key
}

resource "linode_nodebalancer_node" "awesome_cluster_lb_node" {
  # Required
  label           = var.label
  nodebalancer_id = linode_nodebalancer.awesome_cluster_lb.id
  config_id       = linode_nodebalancer_config.awesome_cluster_lb_config.id
  address         = "${element(local.lke_node_ips, count.index)}:80"
  # Optional
  mode   = var.mode == "" ? null : var.mode
  weight = var.weight == "" ? null : var.weight
  count  = var.nodes_count == "" ? null : var.nodes_count

}