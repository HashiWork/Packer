# Identifiants API Proxmox
api_username             = "root@pam"
api_password             = "P***"

# Accès SSH à la VM (compte créé dans preseed.cfg)
ssh_username             = "mco"
ssh_password             = "***"

# Paramètres techniques de la VM
bios_type                = "seabios"
boot_command             = "<esc><wait>auto console-keymaps-at/keymap=fr console-setup/ask_detect=false debconf/frontend=noninteractive fb=false url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"
boot_wait                = "10s"
bridge_name              = "vmbr0"
bridge_firewall          = false
cloud_init               = false
cpu_type                 = "x86-64-v2-AES"
disk_discard             = true
disk_format              = "raw"
disk_size                = "20G"
disk_type                = "scsi"
iso_file                 = "local:iso/debian-12amd64.iso"
machine_default_type     = "q35"
nb_core                  = 2
nb_cpu                   = 2
nb_ram                   = 4096
network_model            = "virtio"
io_thread                = false
os_type                  = "l26"
proxmox_api_url          = "https://***:8006/api2/json"
proxmox_node             = "proxmox"
qemu_agent_activation    = true
scsi_controller_type     = "virtio-scsi-pci"
ssh_handshake_attempts   = 6
ssh_timeout              = "35m"
storage_pool             = "local-lvm"
tags                     = "vm"
vm_id                    = 4000
vm_info                  = "Debian 12 Packer Template"
vm_name                  = "debian-12-template"
