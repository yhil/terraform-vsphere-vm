resource "vsphere_virtual_machine" "virtual_machine_windows" {
  
  name             = var.name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.ds.id

  num_cpus = var.num_cpus
  memory   = var.memory
  scsi_type= data.vsphere_virtual_machine.template.scsi_type
  guest_id = data.vsphere_virtual_machine.template.guest_id

  wait_for_guest_net_timeout = var.wait_for_guest_net_timeout

  network_interface {
     network_id = data.vsphere_network.network.id 
  }

  disk {
    label            = "disk0"
    size             = var.disk_size != "" ? var.disk_size : data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.linked_clone

    customize {
      windows_options {
        computer_name         = var.name
        admin_password        = var.admin_password
        join_domain           = var.domain_name
        domain_admin_user     = var.domain_admin_user
        domain_admin_password = var.domain_admin_password
        time_zone             = var.time_zone != "" ? var.time_zone : "110"
      }

      network_interface {
        ipv4_address    = var.ipv4_network_address
        ipv4_netmask    = var.ipv4_netmask
        dns_server_list = var.dns_servers
        dns_domain      = var.domain_name
      }

      ipv4_gateway = var.ipv4_gateway
    }
  }
}