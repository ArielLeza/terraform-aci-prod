resource "aci_vrf" "vrf1" {
  tenant_dn = aci_tenant.tenant1.id
  name      = "VRF-Prod"
}

resource "aci_bridge_domain" "bd1" {
        tenant_dn                   = "${aci_tenant.tenant1.id}"
        name                        = "bd1"
        arp_flood                   = "yes"
        host_based_routing          = "yes"
    }

resource "aci_bridge_domain" "bd2" {
        tenant_dn                   = "${aci_tenant.tenant1.id}"
        name                        = "bd2"
        arp_flood                   = "yes"
        host_based_routing          = "yes"

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
