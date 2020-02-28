provider "vsphere" {
    user            = var.vsphere_user
    password        = var.vsphere_password
    vsphere_server  =  var.vsphere_vcenter
    allow_unverified_ssl = true
}


module "Test-Windows" {
  source                = "../Windows"
  template_name         = "TEMPLATE_WINDOWS2016"
  resource_pool         = "Production/Resources"
  name                  = "Test-Windows"
  datastore             = "Datastore-Various"
  ipv4_network_address  = "192.168.0.20"
  num_cpus              = "2"
  memory                = "4096"
 vm_disks = [
    {
      label = "disk0"
      size = 40 
      unit_number = 0
    }
  ],
   vm_disks = [
    {
      label = "disk1"
      size = 500 
      unit_number = 1
    }
  ]
  domain_admin_user     = var.aduser_username
  domain_admin_password = var.aduser_password
}

module "Test-Linux" {
  source                = "../Linux"
  resource_pool         = "Production/Resources"
  template_name         = "TEMPLATE_UBUNTU_1804_LTS"
  name                  = "Test-Linux"
  datastore             = "Datastore-Various"
  ipv4_network_address  = "192.168.0.21"
  num_cpus              = "2"
  memory                = "2048"
 vm_disks = [
    {
      label = "disk0"
      size = 16 
      unit_number = 0
    }
  ]

}
