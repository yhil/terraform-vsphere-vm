variable "vsphere_user" {
    description = "The user of the vSphere account"
}

variable "vsphere_password" {
    description = "The password of the vSphere account"
  
}

variable "vsphere_vcenter" {
    description = "The vCSA DNS name to connect to vSphere"
    default     = "vsphere-p1.lab.local"
}


variable "aduser_username" {
    description = "The aduser uname to add the computer to the domain emea.thermo.com"
  
}

variable "aduser_password" {
  description = "The aduser password for the aduser to add the computer to the domain emea.thermo.com"
}

