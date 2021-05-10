variable "tenantName" {
  default = "Weizmann-TFC"
}

variable "aciUser" {
  default = "apic:backmeup\\\\admin"
}

variable "password" {
  default = "C!sco12345Fallback"
}

variable "aciPrivateKey" {
  default = ""
}

variable "aciCertName" {
  default = ""
}

variable "aciUrl" {
  default = "https://192.118.76.196"
}

variable "bd1Subnet" {
  type    = string
  default = "1.1.1.1/24"
}

variable "bd2Subnet" {
  type    = string
  default = "1.1.2.1/24"
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
