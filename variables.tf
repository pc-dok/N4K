variable "prefix" {
  type = "string"
  default = "UAC"
  description = "The prefix used for all resources in this example. Needs to be a short (6 characters) alphanumeric string. Example: `myprefix`."
}

variable "admin_username" {
  type = "string"
  default = "ctxadmin"
  description = "The username of the administrator account for both the local accounts, and Active Directory accounts. Example: `myexampleadmin`"
}

variable "admin_password" {
  type = "string"
  default = "Citrix_2019"
  description = "The password of the administrator account for both the local accounts, and Active Directory accounts. Needs to comply with the Windows Password Policy. Example: `PassW0rd1234!`"
}

variable "active_directory_domain" {
  type = "string"
  default = "uac.local"
  description = "The name of the Active Directory domain, for example `consoto.local`"
}

variable "active_directory_netbios_name" {
  type = "string"
  default = "UAC"
  description = "The netbios name of the Active Directory domain, for example `consoto`"
}

variable "RG_Compute" {
  type = "string"
  default = "RG3_UAC_Compute"
  description = "Ressoure Group for Compute - VM"
}
variable "RG_Storage" {
  type = "string"
  default = "RG3_UAC_Storage"
  description = "Ressoure Group for Storage"
}
variable "RG_Network" {
  type = "string"
  default = "RG3_UAC_Network"
  description = "Ressoure Group for Netowrk"
}
variable "storlrs" {
  type = "string"
  default = "rg3storageuaclrs"
  description = "Storage Account for Standard LRS"
}

variable "storlrsdiag" {
  type = "string"
  default = "rg3storageuaclrsdiag"
  description = "Storage Account for Boot Diagnostic"
}
variable "storlrsssd" {
  type = "string"
  default = "rg3storageuacssd"
  description = "Storage Account for Premium Storage - SSD"
}
variable "azlocation" {
  type = "string"
  default = "westeurope"
  description = "The netbios name of the Active Directory domain, for example `consoto`"
}
variable "vnet" {
  type = "string"
  default = "UACTF-vnet"
  description = "The vnet name of the Virtual Private Network"
}
variable "dc1" {
  type = "string"
  default = "UACTF-ADS-001"
  description = "The vm name of the First Domain Controller"
}
variable "dc2" {
  type = "string"
  default = "UACTF-ADS-002"
  description = "The vm name of the Second Domain Controller"
}
variable "jh" {
  type = "string"
  default = "UACTF-MGT-001"
  description = "The vm name of the Jumping and Management Host"
}

variable "ansible" {
  type = "string"
  default = "UACTF-LXA-001"
  description = "The vm name of the Ansible Control Machine"
}