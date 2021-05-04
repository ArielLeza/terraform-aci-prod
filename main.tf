provider "aci" {
  username    = var.aciUser
  ## private_key = var.aciPrivateKey
  password    = var.password
  ## cert_name   = var.aciCertName
  insecure    = true
  url         = var.aciUrl
}

data "aci_tenant" "common" {
  name = "common"
}

data "aci_l3_outside" "internet" {
  tenant_dn = data.aci_tenant.common.id
  name      = var.l3OutName
}

resource "aci_tenant" "demo" {
  name        = var.tenantName
  description = "automated by terraform for Eyal"
}

resource "aci_vrf" "vrf1" {
  tenant_dn = aci_tenant.demo.id
  name      = "VRF-Prod"
}

resource "aci_bridge_domain" "bd1" {
  tenant_dn                = aci_tenant.demo.id
  relation_fv_rs_ctx       = aci_vrf.vrf1.id
  relation_fv_rs_bd_to_out = [data.aci_l3_outside.internet.id]
  name                     = "bd1"
}
resource "aci_bridge_domain" "bd2" {
  tenant_dn                = aci_tenant.demo.id
  relation_fv_rs_ctx       = aci_vrf.vrf1.id
  relation_fv_rs_bd_to_out = [data.aci_l3_outside.internet.id]
  name                     = "bd2"
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


resource "aci_rest" "bd1public" {
  depends_on = [aci_subnet.bd1_subnet]
  path       = "/api/node/mo/uni/tn-${var.tenantName}/BD-bd1/subnet-[${var.bd1Subnet}].json"
  payload    = <<EOF
  {"fvSubnet":
    {"attributes":
      {"dn":"uni/tn-${var.tenantName}/BD-bd1/subnet-[${var.bd1Subnet}]",
       "scope":"public,shared"
      },
      "children":[]
    }
  }
  EOF
}

resource "aci_rest" "bd2public" {
  depends_on = [aci_subnet.bd2_subnet]
  path       = "/api/node/mo/uni/tn-${var.tenantName}/BD-bd2/subnet-[${var.bd2Subnet}].json"
  payload    = <<EOF
  {"fvSubnet":
    {"attributes":
      {"dn":"uni/tn-${var.tenantName}/BD-bd2/subnet-[${var.bd2Subnet}]",
       "scope":"public,shared"
      },
      "children":[]
    }
  }
  EOF
}


resource "aci_application_profile" "app1" {
  tenant_dn = aci_tenant.demo.id
  name      = "CtoBeLike_APP"
}

data "aci_vmm_domain" "vds" {
  provider_profile_dn = var.provider_profile_dn
  name                = var.vmmDomain
}

resource "aci_application_epg" "epg1" {
  application_profile_dn = aci_application_profile.app1.id
  name                   = "FrontEnd_EPG"
  relation_fv_rs_bd      = aci_bridge_domain.bd1.id
  relation_fv_rs_cons    = [aci_contract.contract_epg1_epg2.id, data.aci_contract.default.id]
}

resource "aci_epg_to_domain" "vmmepg1" {

  application_epg_dn    = aci_application_epg.epg1.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}

resource "aci_epg_to_domain" "vmmepg2" {

  application_epg_dn    = aci_application_epg.epg2.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}

resource "aci_application_epg" "epg2" {
  application_profile_dn = aci_application_profile.app1.id
  name                   = "DataBase"
  relation_fv_rs_bd      = aci_bridge_domain.bd2.id
  relation_fv_rs_prov    = [aci_contract.contract_epg1_epg2.id]
  relation_fv_rs_cons    = [data.aci_contract.default.id]
}

resource "aci_contract" "contract_epg1_epg2" {
  tenant_dn = aci_tenant.demo.id
  name      = "CryptoMineSecurityPolicy_Con"
}


data "aci_contract" "default" {
  tenant_dn = data.aci_tenant.common.id
  name      = "default"
}

resource "aci_contract_subject" "Web_subject1" {
  contract_dn                  = aci_contract.contract_epg1_epg2.id
  name                         = "Subject"
  relation_vz_rs_subj_filt_att = [aci_filter.allow_https.id, aci_filter.allow_icmp.id]
}

resource "aci_filter" "allow_https" {
  tenant_dn = aci_tenant.demo.id
  name      = "allow_https"
}

resource "aci_filter" "allow_icmp" {
  tenant_dn = aci_tenant.demo.id
  name      = "allow_icmp"
}

resource "aci_filter_entry" "https" {
  name        = "https"
  filter_dn   = aci_filter.allow_https.id
  ether_t     = "ip"
  prot        = "tcp"
  d_from_port = "8080"
  d_to_port   = "8080"
  stateful    = "yes"
}

resource "aci_filter_entry" "icmp" {
  name      = "icmp"
  filter_dn = aci_filter.allow_icmp.id
  ether_t   = "ip"
  prot      = "icmp"
  stateful  = "yes"
}
