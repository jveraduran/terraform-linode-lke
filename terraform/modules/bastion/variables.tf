variable "image_id" {
  description = "Private Image ID generated from Packer (required)"
  type        = string
}

variable "region" {
  description = "The region where your cluster will be located. (required)"
  type        = string
}