provider "aci" {
  username    = var.aciUser
  ## private_key = var.aciPrivateKey
  password    = var.password
  ## cert_name   = var.aciCertName
  insecure    = true
  url         = var.aciUrl
}

resource "aci_tenant" "demo" {
  name        = var.tenantName
  description = "automated by terraform for Weizmann"
}

resource "aci_vrf" "vrf1" {
  tenant_dn = aci_tenant.demo.id
  name      = "VRF-Prod"
}

resource "aci_subnet" "bd1_subnet" {
  parent_dn = aci_bridge_domain.bd1.id
  ip        = var.bd1Subnet
  scope     = ["shared"]
}

resource "aci_subnet" "bd2_subnet" {
  parent_dn = aci_bridge_domain.bd2.id
  ip        = var.bd2Subnet
  scope     = ["shared"]
}
