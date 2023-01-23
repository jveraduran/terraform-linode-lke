terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.17.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}
provider "linode" {
  token = var.token
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
    cluster_ca_certificate = try(base64decode(yamldecode(file("./cluster.yaml")).clusters[0].cluster.certificate-authority-data), null)
  }
}

