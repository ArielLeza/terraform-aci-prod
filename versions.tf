#terraform {
#  required_version = ">= 0.13"
#  required_providers {
#    aci = {
#      source = "ciscodevnet/aci"
#      version = "0.7.1"
#    }
#  }
#}

terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.0.1"
    }
  }
}
