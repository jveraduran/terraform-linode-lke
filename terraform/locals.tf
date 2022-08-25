locals {
  lke_node_ids = flatten(
    [for pool in linode_lke_cluster.awesome_cluster.pool :
      [for node in pool.nodes : node.instance_id]
    ]
  )
  lke_node_ips = data.linode_instances.awesome_cluster.instances.*.private_ip_address
}