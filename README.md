# tf-module-kvm-vm
Terraform module to create a KVM VM via libvirt.

Examples:
- [https://github.com/k-candidate/tf-nfs](https://github.com/k-candidate/tf-nfs)
- [https://github.com/k-candidate/tf-jenkins-as-code](https://github.com/k-candidate/tf-jenkins-as-code)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | = 0.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | = 0.7.1 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [libvirt_cloudinit_disk.cloudinit_resized](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.vm](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/domain) | resource |
| [libvirt_volume.vm_disk](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/volume) | resource |
| [libvirt_volume.vm_disk_resized](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/volume) | resource |
| [null_resource.run_ansible](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_cloud_init](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_dir"></a> [ansible\_dir](#input\_ansible\_dir) | Directory where Ansible files are located | `string` | `"ansible"` | no |
| <a name="input_ansible_requirements"></a> [ansible\_requirements](#input\_ansible\_requirements) | Ansible requirements filename. It should be inside the ansible\_dir directory | `string` | `"requirements.yml"` | no |
| <a name="input_cloud_init_cfg_filename"></a> [cloud\_init\_cfg\_filename](#input\_cloud\_init\_cfg\_filename) | Filename of the cloud-init cfg file. | `string` | `null` | no |
| <a name="input_cloud_init_vars"></a> [cloud\_init\_vars](#input\_cloud\_init\_vars) | A map of variables to pass to the user data template | `map(string)` | `{}` | no |
| <a name="input_enable_cpu_passthrough"></a> [enable\_cpu\_passthrough](#input\_enable\_cpu\_passthrough) | Enable CPU host passthrough mode | `bool` | `false` | no |
| <a name="input_extra_vars"></a> [extra\_vars](#input\_extra\_vars) | Optional Ansible extra variables to pass to the playbook | `map(any)` | `{}` | no |
| <a name="input_image_source"></a> [image\_source](#input\_image\_source) | Path to local, or HTTP(S) urls for remote image. | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory for the VM in MB. | `number` | `1024` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network to attach the VM. | `string` | n/a | yes |
| <a name="input_playbook"></a> [playbook](#input\_playbook) | Ansible playbook filename | `string` | `"playbook.yml"` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | The SSH private key to use to connect to the VM. | `string` | `null` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The SSH public key for the VM when using cloud-init. Use this variable inside your user-data file. | `string` | `null` | no |
| <a name="input_storage_pool"></a> [storage\_pool](#input\_storage\_pool) | The storage pool where the storage will be created. | `string` | `"default"` | no |
| <a name="input_use_ansible"></a> [use\_ansible](#input\_use\_ansible) | Set to true to run Ansible, false otherwise. | `bool` | `false` | no |
| <a name="input_use_cloud_init"></a> [use\_cloud\_init](#input\_use\_cloud\_init) | Set to true to use the cloud-init cfg file, false otherwise. | `bool` | `false` | no |
| <a name="input_vcpu"></a> [vcpu](#input\_vcpu) | The number of vCPUs for the VM. | `number` | `1` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the virtual machine. | `string` | n/a | yes |
| <a name="input_vm_username"></a> [vm\_username](#input\_vm\_username) | The username for the VM when using cloud-init | `string` | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the VM disk in bytes. | `number` | `10737418240` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->