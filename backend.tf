terraform {
  backend "s3" {
    bucket  = "harness-deluxe-terraform-state-files"
    key     = "terraform-linode-lke/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
