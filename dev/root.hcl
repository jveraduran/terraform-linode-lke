locals {
  environment       = "dev"
  aws_access_key    = get_env("AWS_ACCESS_KEY_ID", "")
  aws_secret_key    = get_env("AWS_SECRET_ACCESS_KEY", "")
}

inputs = {
  environment       = local.environment
  aws_access_key    = local.aws_access_key
  aws_secret_key    = local.aws_secret_key

  region               = "us-east"
  image_id             = "private/33089839"
  type                 = "g6-standard-1"
  label                = "linode_cluster"
  k8s_version          = "1.32"
  nodes_count          = 1
  tags                 = ["linode_cluster", "labs", "k8s"]
  client_conn_throttle = 20
  pool = [
  {
    type  = "g6-standard-4"
    count = 1
  }
  ]
  swap_size       = 256
  private_ip      = true
  booted          = true
}
