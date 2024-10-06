terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
    }
  }
}
provider "linode" {
  token = var.token
}

provider "harness" {
  endpoint         = var.harness_manager_endpoint
  account_id       = var.harness_account_id
  platform_api_key = var.harness_platform_api_key
}

provider "kubernetes" {
  host                   = module.lke.api_endpoints[0]
  token                  = try(yamldecode(file("./cluster.yaml")).users[0].user.token, null)
  cluster_ca_certificate = try(base64decode(yamldecode(file("./cluster.yaml")).clusters[0].cluster.certificate-authority-data), null)
}

provider "helm" {
  kubernetes {
    host                   = module.lke.api_endpoints[0]
    token                  = try(yamldecode(file("./cluster.yaml")).users[0].user.token, null)
    config_path            = "./cluster.yaml"
    cluster_ca_certificate = try(base64decode(yamldecode(file("./cluster.yaml")).clusters[0].cluster.certificate-authority-data), null)
  }
}

