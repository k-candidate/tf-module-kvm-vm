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
  template = file("${var.cloud_init_cfg_filename}")
  vars     = var.cloud_init_vars
}

# Use cloud-init
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
    network_name   = var.network_name
    wait_for_lease = true
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

resource "null_resource" "wait_for_cloud_init" {
  count      = var.use_cloud_init ? 1 : 0
  depends_on = [resource.libvirt_domain.vm]

  provisioner "local-exec" {
    command = <<-EOF
      ssh -o StrictHostKeyChecking=no \
      -i '${var.ssh_private_key}' \
      '${var.vm_username}'@'${libvirt_domain.vm.network_interface[0].addresses[0]}' \
      cloud-init status --wait --long
    EOF
  }
}

resource "null_resource" "run_ansible" {
  count = var.use_ansible ? 1 : 0
  depends_on = [
    resource.libvirt_domain.vm,
    null_resource.wait_for_cloud_init
  ]

  connection {
    type        = "ssh"
    user        = var.vm_username
    private_key = file(var.ssh_private_key)
    host        = libvirt_domain.vm.network_interface[0].addresses[0]
  }

  provisioner "remote-exec" {
    inline = ["echo 'VM is ready'"]
  }

  triggers = {
    playbook_hash = filesha512("${var.ansible_dir}/${var.playbook}")
  }

  provisioner "local-exec" {
    working_dir = var.ansible_dir
    command     = <<-EOT
      ansible-playbook -u ${var.vm_username} -i '${libvirt_domain.vm.network_interface[0].addresses[0]},' '${var.playbook}' \
      ${var.extra_vars != {} ? "--extra-vars='${jsonencode(var.extra_vars)}'" : ""}
    EOT
  }
}