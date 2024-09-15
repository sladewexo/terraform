variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA3+KSPhEnw7+7dXcP4k7zyV618k+P7dFkTxYO/ZONUyz2se0UnED2k15YaQIDo4DqalCyk9V7UDHB4Wy4jveObcwOWe/9dJX7WxCGkHLwkG3HCmtSIgBFKKV0a+C5WeC7m1crNvUE/P8xFD4sSX7foXK6RD3R1AyVDYMQCUnRpNcHAMO9fcHdW2BEUNPOCyuR1p5JWOh0KdgIBqeyvBBHNVkhE1twDlGWTdXM/ZeceOssvQKRLq4O5LN2r0Gj2zIZQHKW4tqrFt+CrRP/I5GdDbvhrMrGMiBSzaiYejoL2Lx0quD0mdvZcvm5jarwy8V1xxCtDf/VInJeHEbWEHsSZQ== rsa-key-20231105"
}
variable "proxmox_host" {
    default = "proxmox01"
}
variable "template_name" {
    default = "debian11-cloud-init"
}