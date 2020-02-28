
# terraform-vsphere-virtual-machine
Terraform module to provision and customize Windows and Linux virtual machine in vSphere.
It can be easily used for any vCenter Server by changing a few variables.

Usefull documentation to work with this repository:
- [Terraform Introduction](https://www.terraform.io/intro/index.html)
- [vSphere Provider](https://www.terraform.io/docs/providers/vsphere/index.html)
- Important commands: [init](https://www.terraform.io/docs/commands/init.html) - [plan](https://www.terraform.io/docs/commands/plan.html) - [apply](https://www.terraform.io/docs/commands/apply.html)
- [Backend](https://www.terraform.io/docs/backends/index.html)


# Variables

***If a variable is not required, that mean there is no default value in Linux or Windows module so you need to set the value of the variable in the `main.tf` file used for your deployments.***

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| datacenter | The datacenter to deploy the virtual machines. | string | `Production` | no |
| resource_pool | The resource pool to deploy the virtual machines. If you want to deploy on the root of a cluster use the value CLUSTERNAME/Resources | string | `Production/Resources`| no |
| datastore | The datastore to deploy the virtual machines. | string | - | yes |
| network | The network to deploy virtual machines. | string | `Production Network` | no |
| name | The name to use for virtual machines.| string | `` | yes |
| template_name | The template use to create the virtual machine. | string | `` | no |
| num_cpus | The number of vCPUs to assign to the virtual machine. | string | `1` | no |
| memory | The amount of memory in MB to assign to the virtual machine. | string | `4096` | no |
| disk_size | The disk space to assign to each VM. Leave blank to use the template's disk size. | string | `` | no |
| vm_disks | The virtual disk(s) specifications, to assign each virtual marchines. | list of maps | `[{label='disk0' size=40 unit_number=0 thin_provisioned=false eagerly_scrub=false` | no |
| wait_for_guest_net_timeout | The timeout in minutes to wait when creating virtual machines. If you don't want to put a timeout set it to -1. | string | `10` | no |
| domain_name | The domain of the virtual machine. This is customize the domain for Linux and Windows during curstomization. It will also add Windows OS to the domain.| string | `lab.local` | no |
| domain_admin_user | The domain user to add the virtual machine to the domain | string | - | yes (Windows Only) |
| domain_admin_password |The domain user password to add the virtual machine to the domain | string | - | yes (Windows Only) |
| ipv4_network_address | The network address of the virtual machine. You can leave empty to receive an IP from DHCP. | string | - | no |
| ipv4_gateway | The default IPv4 gateway for the virtual machines. | string | `192.168.0.1` | no |
| dns_servers | The DNS servers for the virtual machine. | list | `["192.168.0.10", "192.168.0.11"]` | no |
| linked_clone | Clone the VM from a snapshot. | string | `false` | no |


# Terraform Process
Process to deploy a virtual machine with terraform-vsphere-virtual-machine:

1. Download terraform in your client
2. Clone the vsphere-virtual-machine repository in your client
3. Modify the required variables default values in the Windows\vars.tf and Linux\vars.tf files
4.  Set your vSphere provider by modifying vars.tf file
5. Declare a module for each virtual machine to create in the main.tf file
6. Initialize the vsphere-module module and vsphere plugins
```terraform init```
7. Plan your changes to verify your running code
```terraform plan```
8. Apply your changes to the infrastructure
```terraform apply```

# Example: Create a Linux and a Windows Server

### Modify default variables from vsphere-module


You need to modify the most usefull default values in ```Linux\vars.tf``` and ```Windows\vars.tf``` from the variables listed below to suit with your environment. All of those are not required to have a successful deployment but are usefull to manage them.

- datacenter => vSphere datacenter
- resource_pool => vSphere Cluster
- network => vSphere Network
- domain_name => Domain 
- ipv4_gateway => Network gateway
- dns_servers => DNS Servers


You change the default value of the variables in ```Windows\vars.tf``` or ```Linux\vars.tf```:

<pre>
variable "datacenter" {
  description = "The datacenter to deploy the virtual machines to."
  type = "string"
  <s>default = "Datacenter"</s>
  default = "new_datacenter_name"
}
</pre>
 
 Or you can overwrite the default value from variable.tf by declare the value in the ```main.tf``` in vsphere-live:

<pre>
module "Test-Windows" {
  source                = "../Windows"
  template_name         = "TEMPLATE_W2K16"
  name                  = "Test-Windows"
  datastore             = "Datastore01"
  ipv4_network_address  = "192.168.20.100"
  <b>datacenter            = "new_datacenter_name"</b>
  <b>ipv4_gateway          = "192.168.20.1"</b>
  <b>dns_servers           = ["192.168.20.10","192.168.0.11"]</b>
  <b>resource_pool			= "Development/Resources"</b>
</pre>
  
### Set your vSphere by  updating the file `vars.tf`

The provider can't be set up in the module so you need to declare those variables to connect to the vSphere.
Update the variable "vsphere_vcenter" with the name or ip of your vCenter.

For the 4 others variables are use to connect to the vSphere and connect a Windows OS to an Active Directory domain. You can set your default or you will be prompt for those informations when you run terraform plan and apply.

<pre><code>
variable "vsphere_user" {
    description = "The user of the vSphere account"
}

variable "vsphere_password" {
    description = "The password of the vSphere account"
  
}

variable "vsphere_vcenter" {
    description = "The vCSA DNS name to connect to vSphere"
    default     = "vshere.lab.local"
}


variable "aduser_username" {
    description = "The aduser uname to add the computer to the domain emea.thermo.com"
  
}

variable "aduser_password" {
  description = "The aduser password for the aduser to add the computer to the domain emea.thermo.com"
}
</pre></code>

### Define the Virtual machines by updating the file `main.tf`

Here we are interested by the two modules sections.
We declare a module for each of the servers that we want to deploy, in this case: Test-Windows, Test-Linux


<pre><code>module "Test-Windows" {
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
      size = 150 
      unit_number = 0
    }
  ]

}</pre></code>



### Run the deployment
1. Open a command shell and move to the directory where the `main.tf` and `vars.tf` belongs to.
1. Run the command ```terraform init``` to initialize the bakend, the module and the plugin
1. Run the command ```terraform plan``` to see the changes who will be apply by your configuration
1. Run the command ```terraform apply``` to apply the changes
1. Read the outputs give by your shell to verify that the deployment went well


# Choose a backend

After each deployment terraform will save the state of it in local files. 
You can choose a backend to store the state files off disk and protect the state with locks  to prevent corruption when you run terraform.
You can find the backend list in [terraform website](https://www.terraform.io/docs/backends/types/artifactory.html#docs-backends-types-standard).

Tip: if you have access to an Amazon S3, it's an easy and an efficient way to create a bucket and use it to store the state files: [Amazon S3 backend for terraform](https://www.terraform.io/docs/backends/types/s3.html)

