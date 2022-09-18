variable "token" {
  description = "Your Linode API Access Token (required)"
}
variable "nodes_count" {
  description = "Worker nodes count(required)"
  default     = "3"
}
variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster. (required)"
  default     = "1.23"
}

variable "label" {
  description = "The unique label to assign to this cluster. (required)"
  default     = "linode_cluster"
}

variable "region" {
  description = "The region where your cluster will be located. (required)"
  default     = "us-east"
}

variable "tags" {
  description = "Tags to apply to your cluster for organizational purposes. (optional)"
  type        = list(string)
  default     = ["linode_cluster", "labs", "k8s"]
}
variable "client_conn_throttle" {
  description = "Throttle connections per second (0-20). Set to 0 (default) to disable throttling (optional)"
  default     = "20"
}

variable "pool" {
  description = "The Node Pool specifications for the Kubernetes cluster. (required)"
  type = list(object({
    type  = string
    count = number
  }))
  default = [
    {
      type  = "g6-standard-1"
      count = 3
    }
  ]
}
