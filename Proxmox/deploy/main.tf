##########################################
#       Terraform Proxmox Tutorial       #
##########################################

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
 
  pm_api_url = "https://192.168.100.201:8006/api2/json"
  
  pm_api_token_id = "terraform@pam!terraform"
  
  pm_api_token_secret = "5803723e-6b7f-4883-bd12-d7e126a08a33"
  
  pm_tls_insecure = true
}

# resource is formatted to be "[type]" "[entity_name]"
resource "proxmox_vm_qemu" "test_server" {
  count = 1 # just want 1 for now
  name = "debian-vm-${count.index + 1}" #count.index starts at 0, so + 1 means this VM will be named debian-vm-1 in proxmox
  # this now reaches out to the vars file.
  target_node = var.proxmox_host
  # another variable with contents "debian-cloudinit-template"
  clone = var.template_name
  # basic VM settings here. agent refers to guest agent
  agent = 0
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    # set disk size here.
    size = "8G"
    type = "scsi"
    storage = "Storage" # name of your proxmox storage
    iothread = 0
  }
  
 network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  
  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 192.168.100.91 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)
  ipconfig0 = "ip=192.168.100.9${count.index + 1}/24,gw=192.168.100.1"
  
  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}