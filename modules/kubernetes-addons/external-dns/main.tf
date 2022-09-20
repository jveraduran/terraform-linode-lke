resource "helm_release" "external_dns" {
  name             = local.default_helm_config["name"]
  repository       = local.default_helm_config["repository"]
  chart            = local.default_helm_config["name"]
  version          = local.default_helm_config["version"]
  namespace        = local.default_helm_config["namespace"]
  create_namespace = local.default_helm_config["create_namespace"]
  force_update     = local.default_helm_config["force_update"]
}