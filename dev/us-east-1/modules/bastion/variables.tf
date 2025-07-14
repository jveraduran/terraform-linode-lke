variable "region" {
  description = "The region where your cluster will be located. (required)"
  type        = string
}

variable "type" {
  description = ""
  type        = string
}
variable "image_id" {
  description = "Private Image ID generated from Packer (required)"
  type        = string
  default     = null
}

variable "swap_size" {
  description = ""
  type        = number
  default     = null
}

variable "group" {
  description = ""
  type        = string
  default     = null
}

variable "label" {
  description = ""
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to your cluster for organizational purposes. (optional)"
  type        = list(string)
  default     = []
}

variable "private_ip" {
  description = ""
  type        = bool
  default     = false
}

variable "shared_ipv4" {
  description = ""
  type        = list(string)
  default     = []
}

variable "resize_disk" {
  description = ""
  type        = bool
  default     = false
}

variable "backups_enabled" {
  description = ""
  type        = bool
  default     = false
}

variable "watchdog_enabled" {
  description = ""
  type        = string
  default     = null
}

variable "authorized_keys" {
  description = ""
  type        = list(string)
  default     = []
}

variable "authorized_users" {
  description = ""
  type        = list(string)
  default     = []
}

variable "root_pass" {
  description = ""
  type        = string
  default     = null
}

variable "stackscript_id" {
  description = ""
  type        = string
  default     = null
}

variable "stackscript_data" {
  description = ""
  type        = map(string)
  default     = null
}

variable "backup_id" {
  description = ""
  type        = string
  default     = null
}

variable "booted" {
  description = ""
  type        = bool
  default     = false
}

variable "interface" {
  description = ""
  type        = map(string)
  default     = null
}

variable "disk" {
  description = ""
  type        = map(string)
  default     = null
}
