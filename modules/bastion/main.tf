resource "linode_instance" "bastion" {
  # Required
  region = var.region
  type   = var.type
  # Optional
  label            = var.label == "" ? null : var.label
  image            = var.image_id == "" ? null : var.image_id
  group            = var.group == "" ? null : var.group
  tags             = var.tags == "" ? null : var.tags
  swap_size        = var.swap_size == "" ? null : var.swap_size
  private_ip       = var.private_ip == "" ? null : var.private_ip
  shared_ipv4      = var.shared_ipv4 == "" ? null : var.shared_ipv4
  resize_disk      = var.resize_disk == "" ? null : var.resize_disk
  backups_enabled  = var.backups_enabled == "" ? null : var.backups_enabled
  watchdog_enabled = var.watchdog_enabled == "" ? null : var.watchdog_enabled
  booted           = var.booted == "" ? null : var.booted
  authorized_keys  = var.authorized_keys == "" ? null : var.authorized_keys
  authorized_users = var.authorized_users == "" ? null : var.authorized_users
  root_pass        = var.root_pass == "" ? null : var.root_pass
  stackscript_id   = var.stackscript_id == "" ? null : var.stackscript_id
  stackscript_data = var.stackscript_data == "" ? null : var.stackscript_data
  backup_id        = var.backup_id == "" ? null : var.backup_id

  dynamic "interface" {
    for_each = var.interface != null ? [var.interface] : []
    content {
      purpose      = lookup(interface.value, "purpose", null)
      label        = lookup(interface.value, "label", null)
      ipam_address = lookup(interface.value, "ipam_address", null)
    }
  }
}