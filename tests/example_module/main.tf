##############################################################################
# IBM Provider
##############################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

##############################################################################

##############################################################################
# Resource Group
##############################################################################

data "ibm_resource_group" "resource_group" {
  name = "default"
}

##############################################################################

##############################################################################
# Example Module
##############################################################################

module "key_management" {
  source            = "../../"
  tags              = var.tags
  region            = var.region
  prefix            = var.prefix
  endpoints         = "public"
  resource_group_id = data.ibm_resource_group.resource_group.id
  keys              = [
    {
      "name" : "key",
      "root_key" : true,
      "force_delete" : true,
      "rotation" : 1,
      "dual_auth_delete" : false
    },
    {
      "name" : "atracker-key",
      "root_key" : true,
      "force_delete" : true,
      "rotation" : 1,
      "dual_auth_delete" : false
    },
    {
      "name" : "vsi-volume-key",
      "root_key" : true,
      "force_delete" : true,
      "rotation" : 1,
      "dual_auth_delete" : false
    },
    {
      "name" : "roks-key",
      "root_key" : true,
      "force_delete" : null,
      "rotation" : 1,
      "dual_auth_delete" : false
    },
    {
      "name" : "icd-key",
      "root_key" : true,
      "force_delete" : null,
      "rotation" : 1,
      "dual_auth_delete" : false
    }
  ]
}

