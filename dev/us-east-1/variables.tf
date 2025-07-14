variable "harness_account_id" {
  description = "Harness Account ID. (required)"
  default     = "UCBJyOkwRy69wQkDOgpexg"
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

variable "aws_access_key" {
  description = "AWS access key ID (optional)"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret access key (optional)"
  type        = string
}

variable "aws_session_token" {
  description = "AWS session token for temporary credentials (optional)"
  type        = string
}

variable "nodes_count" {
  description = "Worker nodes count(required)"
  default     = "1"
}

variable "image_id" {
  description = "The image ID to use for the Linode instance (required if booted = true)"
  type        = string
}

variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster. (required)"
  default     = "1.32"
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
