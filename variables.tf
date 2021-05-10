variable "tenantName" {
  default = "Eyal-TFC"
}

variable "aciUser" {}

variable "password" {}

variable "aciPrivateKey" {}

variable "aciCertName" {}

variable "aciUrl" {}

variable "bd1Subnet" {
  type    = string
  default = "1.1.1.254/24"
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
