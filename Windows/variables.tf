variable "datacenter" {
  description = "The datacenter to deploy the virtual machines."
  type = string
  default = "Production"
}

variable "resource_pool" {
  description = "The resource pool to deploy the virtual machines."
  default     = ""
}

variable "datastore" {
  type        = string
  description = "The datastore to deploy the virtual machines."
}

variable "network" {
  description = "The vSphere network to deploy virtual machines."
  type        = string
  default     = "Production"
}

variable "name" {
  type        = string
  description = "The name for the virtual machine"
}

variable "template_name" {
  description = "The template use to create the virtual machines."
  default     = ""
}

variable "num_cpus" {
  description = "The number of vCPUs to assign to the virtual machine."
  default     = "1"
}

variable "memory" {
  description = "The amount of memory in MB to assign to the virtual machine."
  default     = "4096"
}

variable "disk_size" {
  description = "The amount of disk space to assign to each VM. Leave blank to use the template's disk size (cloned VMs only)."
  default     = ""
}

variable "vm_disks" {
  description = "The virtual disk(s) specifications, to assign each virtual marchines"
  default = [
    {
      label = "disk0"
      size = 40
      unit_number = 0
      thin_provisioned = false
      eagerly_scrub = false
    }
  ]
}

variable "ipv4_network_address" {
  description = "The network address of the virtual machine. You can leave empty to receive an IP from DHCP."
  default     = ""
}

variable "ipv4_netmask" {
    description = "The netmask for the ipv4_network_address"
    default = 24
}

variable "ipv4_gateway" {
  description = "The default IPv4 gateway for the virtual machines."
  default     = "Gateway"
}

variable "dns_servers" {
  description = "The DNS servers for the virtual machine."
  default     = ["DNS1", "DNS2"]
}

variable "domain_name" {
  description = "The domain of the virtual machine. This is customize the domain for Linux and Windows during curstomization. It will also add Windows OS to the domain."
  default     = "Domain"
}

variable "domain_admin_user" {
  description = "The domain user to add the virtual machine to the domain"
}
variable "domain_admin_password" {
  description = "The domain user password to add the virtual machine to the domain"
}

variable "admin_password" {
  description = "The administrator password for Windows machines. This is a sensitive field and will not be output on-screen, but is stored in state and sent to the VM in plain text - keep this in mind when provisioning your infrastructure."
  default     = ""
}

variable "wait_for_guest_net_timeout" {
  description = "The timeout in minutes to wait when creating virtual machines. If you don't want to put a timeout set it to -1"
  default     = "10"
}

variable "time_zone" {
  description = "The timezone."
  default = ""
}

variable "linked_clone" {
  description = "Clone the VM from a snapshot."
  default     = "false"
}
