data "linode_instances" "awesome_cluster" {
  filter {
    name   = "id"
    values = local.lke_node_ids
  }
}