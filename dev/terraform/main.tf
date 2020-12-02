resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = 1
  name              = "tf-vm-${count.index}"
  target_node       = "proxmox"

  clone             = "template-Centos8"
  full_clone        = true

  os_type           = "centos"
  cores             = 1*2
  sockets           = "1"
  cpu               = "host"
  memory            = 1024*4
  balloon           = 1
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"

  disk {
    id              = 0
    size            = 20
    type            = "scsi"
    storage         = "data-1"
    storage_type    = "lvm"
    iothread        = true
  }

  network {
    id              = 0
    model           = "virtio"
    bridge          = "vmbr0"
  }

  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0         = "ip=10.0.1.10${count.index + 1}/24,gw=10.0.1.1"

}
