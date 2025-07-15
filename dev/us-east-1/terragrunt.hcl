include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  aws_access_key    = get_env("AWS_ACCESS_KEY_ID", "")
  aws_secret_key    = get_env("AWS_SECRET_ACCESS_KEY", "")
}

inputs = {
  aws_access_key    = local.aws_access_key
  aws_secret_key    = local.aws_secret_key
}
