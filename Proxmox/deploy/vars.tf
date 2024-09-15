variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDD9vMkB6UiEud2BnnuEOxB8TTqdNBTF4ZYS1BGxjnWa ericdp@Erics-Laptop.local"
}
variable "proxmox_host" {
    default = "pve01"
}
variable "template_name" {
    default = "ubuntu-cloudinit"
}
