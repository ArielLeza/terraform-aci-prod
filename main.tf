provider "aci" {
  username    = var.aciUser
  ## private_key = var.aciPrivateKey
  password    = var.password
  ## cert_name   = var.aciCertName
  insecure    = true
  url         = var.aciUrl
}

resource "aci_tenant" "tenant1" {
  name        = var.tenantName
  description = "automated by terraform Cloud"
}

data "aci_vmm_domain" "vds" {
  provider_profile_dn = var.provider_profile_dn
  name                = var.vmmDomain
}
