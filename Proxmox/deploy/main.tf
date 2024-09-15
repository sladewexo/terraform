##########################################
#       Terraform Proxmox Tutorial       #
##########################################

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://172.16.1.61:8006/api2/json"
  pm_api_token_id = "terraform@pve!terraform"
  pm_api_token_secret = "31e86197-95e3-416f-af03-3447660f0c12"
  pm_tls_insecure = true
}

# resource is formatted to be "[type]" "[entity_name]"
resource "proxmox_vm_qemu" "prepprovision-test" {
  count = 3 # just want 1 for now
  name = "centos-vm-${count.index + 1}" #count.index starts at 0, so + 1 means this VM will be named debian-vm-1 in proxmox
  # this now reaches out to the vars file.
  target_node = var.proxmox_host
  # another variable with contents "debian-cloudinit-template"
  clone = var.template_name
  # basic VM settings here. agent refers to guest agent
  agent = 0
  os_type = "Linux"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"
    disks {
        ide {
            ide3 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        virtio {
            virtio0 {
                disk {
                    size            = 32
                    cache           = "writeback"
                    storage         = "wexam-ceph-pool"
                    storage_type    = "rbd"
                    iothread        = true
                    discard         = true
                }
            }
        }
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
  ipconfig0 = "ip=172.16.1.10${count.index + 1}/24,gw=172.16.1.254"
  
  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
