resource "aci_application_profile" "app1" {
  tenant_dn = aci_tenant.tenant1.id
  name      = "TfcBeLike_APP"
}

resource "aci_application_epg" "epg1" {
  application_profile_dn = aci_application_profile.app1.id
  name                   = "FrontEnd_EPG"
  relation_fv_rs_bd      = aci_bridge_domain.bd1.id
  #relation_fv_rs_cons    = [aci_contract.contract_epg1_epg2.id, data.aci_contract.default.id]
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
