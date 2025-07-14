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
  default     = [""]
}
variable "autoscaler" {
  description = ""
  type        = map(string)
  default     = null
}

variable "control_plane" {
  description = ""
  type        = map(string)
  default     = null
}
variable "client_conn_throttle" {
  description = "Throttle connections per second (0-20). Set to 0 (default) to disable throttling (optional)"
  type        = string
  default     = null
}

variable "pool" {
  description = "The Node Pool specifications for the Kubernetes cluster. (required)"
  type = list(object({
    type  = string
    count = number
  }))
  default = null
}

variable "protocol" {
  description = ""
  type        = string
  default     = null
}

variable "proxy_protocol" {
  description = ""
  type        = string
  default     = null
}
variable "port" {
  description = ""
  type        = number
  default     = null
}

variable "algorithm" {
  description = ""
  type        = string
  default     = null
}

variable "stickiness" {
  description = ""
  type        = string
  default     = null
}

variable "check" {
  description = ""
  type        = string
  default     = null
}

variable "check_interval" {
  description = ""
  type        = number
  default     = null
}

variable "check_timeout" {
  description = ""
  type        = number
  default     = null
}

variable "check_attempts" {
  description = ""
  type        = number
  default     = null
}

variable "check_path" {
  description = ""
  type        = string
  default     = null
}

variable "check_passive" {
  description = ""
  type        = bool
  default     = false
}

variable "cipher_suite" {
  description = ""
  type        = string
  default     = null
}

variable "ssl_cert" {
  description = ""
  type        = string
  default     = null
}

variable "ssl_key" {
  description = ""
  type        = string
  default     = null
}

variable "mode" {
  description = ""
  type        = string
  default     = null
}

variable "weight" {
  description = ""
  type        = number
  default     = null
}

variable "nodes_count" {
  description = "Worker nodes count(required)"
  type        = number
  default     = null
}