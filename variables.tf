variable "harness_account_id" {
  description = "Harness Account ID. (required)"
}

variable "harness_platform_api_key" {
  description = "Harness Platform API Key. (required)"
}

variable "harness_delegate_token" {
  description = "Harness Delegate Token. (required)"
}

variable "harness_manager_endpoint" {
  description = "Harness Manager Endpoint. (required)"
  default     = "https://app.harness.io/gratis"
}

variable "token" {
  description = "Your Linode API Access Token (required)"
}

variable "nodes_count" {
  description = "Worker nodes count(required)"
  default     = "1"
}

variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster. (required)"
  default     = "1.31"
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
      type  = "g6-standard-4"
      count = 1
    }
  ]
}
