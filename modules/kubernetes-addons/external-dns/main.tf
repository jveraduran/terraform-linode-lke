resource "helm_release" "external_dns" {
  depends_on = [
    kubernetes_namespace_v1.this
  ]
  name             = local.default_helm_config["name"]
  repository       = local.default_helm_config["repository"]
  chart            = local.default_helm_config["name"]
  version          = local.default_helm_config["version"]
  namespace        = local.default_helm_config["namespace"]
  create_namespace = local.default_helm_config["create_namespace"]
  force_update     = local.default_helm_config["force_update"]
}

resource "kubernetes_namespace_v1" "this" {
  count = try(local.default_helm_config["create_namespace"], true) && local.default_helm_config["namespace"] != "kube-system" ? 1 : 0
  metadata {
    name = local.default_helm_config["namespace"]
  }
}