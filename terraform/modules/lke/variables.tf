variable "nodes_count" {
  description = "Worker nodes count(required)"
}

variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster. (required)"
  type        = string
}

variable "label" {
  description = "The unique label to assign to this cluster. (required)"
  type        = string
}

variable "region" {
  description = "The region where your cluster will be located. (required)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to your cluster for organizational purposes. (optional)"
  type        = list(string)
}
variable "conn_throttle" {
  description = "Throttle connections per second (0-20). Set to 0 (default) to disable throttling (optional)"
}

variable "pools" {
  description = "The Node Pool specifications for the Kubernetes cluster. (required)"
  type = list(object({
    type  = string
    count = number
  }))
}
