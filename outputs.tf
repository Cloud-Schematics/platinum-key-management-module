##############################################################################
# Key Management Outputs
##############################################################################

output "id" {
  description = "Service ID"
  value       = local.id
}

output "guid" {
  description = "Service GUID"
  value       = local.guid
}

output "keys" {
  description = "List of keys"
  value = [
    for key in var.keys :
    {
      name = key.name
      crn  = ibm_kms_key.encryption_key[key.name].crn
    }
  ]
}

output "key_map" {
  description = "Map of keys"
  value = {
    for key in var.keys :
    (key.name) => {
      name   = key.name
      crn    = ibm_kms_key.encryption_key[key.name].crn
      key_id = ibm_kms_key.encryption_key[key.name].key_id
    }
  }
}

##############################################################################