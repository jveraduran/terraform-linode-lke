locals {
  name      = "external-dns"
  namespace = "external-dns"

  default_helm_config = {
    name             = local.name
    chart            = local.name
    repository       = "https://kubernetes-sigs.github.io/external-dns/"
    version          = "1.11.0"
    namespace        = local.namespace
    force_update     = true
    timeout          = 1200
    create_namespace = true
    description      = "The external-dns Helm Chart deployment configuration"
    wait             = false
  }
}