module "external_dns" {
  count      = var.enable_external_dns ? 1 : 0
  source     = "./external-dns"
}