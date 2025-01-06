# Defining VM volume
resource "libvirt_volume" "vm_disk" {
  name   = "${var.vm_name}-disk_original"
  pool   = var.storage_pool
  format = "qcow2"
  source = var.image_source
}

# Resized volume
resource "libvirt_volume" "vm_disk_resized" {
  count          = var.use_cloud_init ? 1 : 0
  name           = "${var.vm_name}-disk"
  base_volume_id = libvirt_volume.vm_disk.id
  pool           = var.storage_pool
  size           = var.volume_size
}

# Get user data info
data "template_file" "user_data" {
  count    = var.use_cloud_init ? 1 : 0
  template = file("${path.module}/${var.cloud_init_cfg_filename}")
}

# Use cloud-init to add the instance
resource "libvirt_cloudinit_disk" "cloudinit_resized" {
  count     = var.use_cloud_init ? 1 : 0
  name      = "${var.vm_name}-cloudinit.iso"
  pool      = var.storage_pool
  user_data = data.template_file.user_data[0].rendered
}

# Define KVM domain to create
resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory
  vcpu   = var.vcpu

  disk {
    volume_id = var.use_cloud_init ? libvirt_volume.vm_disk_resized[0].id : libvirt_volume.vm_disk.id
  }

  network_interface {
    network_name = var.network_name
  }

  cloudinit = var.use_cloud_init ? libvirt_cloudinit_disk.cloudinit_resized[0].id : null

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }
}