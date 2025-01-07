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