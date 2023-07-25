##############################################################################
# Service Instance
##############################################################################

resource "ibm_resource_instance" "kms" {
  count             = var.create ? 1 : 0
  name              = "${var.prefix}-${var.name}"
  resource_group_id = var.resource_group_id
  service           = "kms"
  plan              = "tiered-pricing"
  location          = var.region
  tags              = var.tags
}

data "ibm_resource_instance" "key_management_data_source" {
  count             = var.create ? 0 : 1
  name              = var.name
  resource_group_id = var.resource_group_id
  service           = local.service_name
}

##############################################################################

##############################################################################
# Locals
##############################################################################

locals {
  id           = var.create ? ibm_resource_instance.kms[0].id : data.ibm_resource_instance.key_management_data_source[0].id
  guid         = var.create ? ibm_resource_instance.kms[0].guid : data.ibm_resource_instance.key_management_data_source[0].guid
  service_name = var.hpcs ? "hs-crypto" : "kms"
}

##############################################################################

##############################################################################
# Authorization Policies to Allow for Block Storage
##############################################################################

resource "ibm_iam_authorization_policy" "kms_server_protect_policy" {
  count                       = var.create_vpc_storage_auth ? 1 : 0
  source_service_name         = "server-protect"
  target_service_name         = local.service_name
  target_resource_instance_id = local.guid
  description                 = "Allow block storage volumes to be encrypted by Key Management instance."
  roles = [
    "Reader"
  ]
}

resource "ibm_iam_authorization_policy" "kms_block_storage_policy" {
  count                       = var.create_vpc_storage_auth ? 1 : 0
  source_service_name         = "is"
  target_service_name         = local.service_name
  target_resource_instance_id = local.guid
  description                 = "Allow block storage volumes to be encrypted by Key Management instance."
  source_resource_type        = "share"
  roles = [
    "Reader",
    "Authorization Delegator"
  ]
}

##############################################################################

##############################################################################
# Create Key Rings
##############################################################################

resource "ibm_kms_key_rings" "ring" {
  key_ring_id = "${var.prefix}-${var.name}-ring"
  instance_id = local.guid
}

##############################################################################

##############################################################################
# Create Keys
##############################################################################

resource "ibm_kms_key" "encryption_key" {
  for_each = {
    for key in var.keys :
    (key.name) => key
  }
  instance_id   = local.guid
  key_name      = "${var.prefix}-${each.value.name}"
  standard_key  = each.value.root_key == false
  key_ring_id   = ibm_kms_key_rings.ring.key_ring_id
  force_delete  = each.value.force_delete == false ? each.value.force_delete : true
  endpoint_type = var.endpoints
  depends_on = [
    ibm_iam_authorization_policy.kms_server_protect_policy,
    ibm_iam_authorization_policy.kms_block_storage_policy
  ]
}

resource "ibm_kms_key_policies" "kms_key_key_policy" {
  for_each = {
    for key in var.keys :
    (key.name) => key
  }
  instance_id   = local.guid
  endpoint_type = var.endpoints
  key_id        = ibm_kms_key.encryption_key[each.value.name].key_id
  rotation {
    interval_month = each.value.rotation != null ? each.value.rotation : 1
  }
  dual_auth_delete {
    enabled = each.value.dual_auth_delete
  }
}

##############################################################################
