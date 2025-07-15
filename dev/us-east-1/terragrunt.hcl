include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  aws_access_key = get_env("AWS_ACCESS_KEY_ID", "")
  aws_secret_key = get_env("AWS_SECRET_ACCESS_KEY", "")

  missing_creds = local.aws_access_key == "" || local.aws_secret_key == ""

  # Falla el plan si no hay credenciales
  sanity_check = local.missing_creds ? error("❌ Faltan las variables de entorno AWS_ACCESS_KEY_ID o AWS_SECRET_ACCESS_KEY") : true
}

inputs = {
  aws_access_key    = local.aws_access_key
  aws_secret_key    = local.aws_secret_key
}
