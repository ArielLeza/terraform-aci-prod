variable "tenantName" {
  default = "SeSuperCloud_tn"
}

variable "aciUser" {
  default = "apic:backmeup\\\\admin"
}

variable "password" {
  default = ""
}

variable "aciPrivateKey" {
  default = ""
}

variable "aciCertName" {
  default = ""
}

variable "aciUrl" {
  default = ""
}

variable "bd1Subnet" {
  type    = string
  default = "172.25.101.1/24"
}

variable "bd2Subnet" {
  type    = string
  default = "172.25.102.1/24"
}


variable "provider_profile_dn" {
  default = "uni/vmmp-VMware"
}

variable "vmmDomain" {
  default = "hxebc"
}

variable "l3OutName" {
  default = "L3-Out-Internet"
}
