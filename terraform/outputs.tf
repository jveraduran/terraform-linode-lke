output "api_endpoints" {
  value = module.lke.api_endpoints
}

output "status" {
  value = module.lke.status
}

output "id" {
  value = module.lke.id
}

output "pool" {
  value = module.lke.pool
}

output "kubeconfig" {
  value     = module.lke.kubeconfig
  sensitive = true
}