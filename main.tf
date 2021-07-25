provider "aci" {
  username    = var.aciUser
  ## private_key = var.aciPrivateKey
  password    = var.password
  ## cert_name   = var.aciCertName
  insecure    = true
  url         = var.aciUrl
}

resource "aci_tenant" "footenant" {
  description = "%s"
  name        = "demo_tenant"
  annotation  = "tag_tenant"
  name_alias  = "alias_tenant"
}
