variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "storage_pool" {
  description = "The storage pool where the storage will be created."
  type        = string
  default     = "default"
}

variable "image_source" {
  description = "Path to local, or HTTP(S) urls for remote image."
  type        = string
}

variable "volume_size" {
  description = "The size of the VM disk in bytes."
  type        = number
  default     = 10737418240 # 10GB = 1024*1024*1024*10
}

variable "use_cloud_init" {
  description = "Set to true to use the cloud-init cfg file, false otherwise."
  type        = bool
  default     = false
}

variable "cloud_init_cfg_filename" {
  description = "Filename of the cloud-init cfg file."
  type        = string
  default     = null
  validation {
    condition     = var.use_cloud_init ? (var.cloud_init_cfg_filename != null && var.cloud_init_cfg_filename != "") : true
    error_message = "cloud_init_cfg_filename must be set when use_cloud_init is true"
  }
}

variable "cloud_init_vars" {
  description = "A map of variables to pass to the user data template"
  type        = map(string)
  default     = {}

  validation {
    condition = var.use_cloud_init ? (
      contains(keys(var.cloud_init_vars), "vm_username") &&
      contains(keys(var.cloud_init_vars), "ssh_public_key")
    ) : true
    error_message = "When use_cloud_init is true, cloud_init_vars must include both 'vm_username' and 'ssh_public_key' keys."
  }
}

variable "vm_username" {
  description = "The username for the VM when using cloud-init"
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "The SSH public key for the VM when using cloud-init. Use this variable inside your user-data file."
  type        = string
  default     = null
}

variable "ssh_private_key" {
  description = "The SSH private key to use to connect to the VM."
  type        = string
  default     = null
}

variable "memory" {
  description = "The amount of memory for the VM in MB."
  type        = number
  default     = 1024
}

variable "vcpu" {
  description = "The number of vCPUs for the VM."
  type        = number
  default     = 1
}

variable "network_name" {
  description = "The name of the network to attach the VM."
  type        = string
}

variable "use_ansible" {
  description = "Set to true to run Ansible, false otherwise."
  type        = bool
  default     = false
}

variable "ansible_dir" {
  description = "Directory where Ansible files are located"
  type        = string
  default     = "ansible"
}

variable "playbook" {
  description = "Ansible playbook filename"
  type        = string
  default     = "playbook.yml"
}

variable "extra_vars" {
  description = "Optional Ansible extra variables to pass to the playbook"
  type        = map(any)
  default     = {}

  validation {
    condition     = length(keys(var.extra_vars)) == length(distinct(keys(var.extra_vars)))
    error_message = "Duplicate keys are not allowed in 'extra_vars'"
  }
}