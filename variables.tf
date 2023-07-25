##############################################################################
# Imported Variables
##############################################################################

variable "tags" {
  description = "List of tags"
  type        = list(string)
}

variable "region" {
  description = "IBM Cloud Region where resources will be provisioned"
  type        = string
  validation {
    error_message = "Region must be in a supported IBM VPC region."
    condition     = contains(["us-south", "us-east", "br-sao", "ca-tor", "eu-gb", "eu-de", "jp-tok", "jp-osa", "au-syd"], var.region)
  }
}

variable "prefix" {
  description = "Name prefix that will be prepended to named resources"
  type        = string
  validation {
    error_message = "Prefix must begin with a lowercase letter and contain only lowercase letters, numbers, and - characters. Prefixes must end with a lowercase letter or number and be 16 or fewer characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])", var.prefix)) && length(var.prefix) <= 24
  }
}

variable "resource_group_id" {
  description = "ID for the resource group where resources will be created"
  type        = string
}

##############################################################################

##############################################################################
# Instance Variables
##############################################################################

variable "create" {
  description = "Create a Key Protect instance for keys"
  type        = bool
  default     = true
}

variable "hpcs" {
  description = "Use an existing HPCS instance to create encryption keys"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name of the key management service instance"
  type        = string
  default     = "kms"
  validation {
    error_message = "Service name must begin with a lowercase letter and contain only lowercase letters, numbers, and - characters. Name must end with a lowercase letter or number."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])", var.name))
  }
}

variable "create_vpc_storage_auth" {
  description = "Create IAM policies to allow VSI storage volumes to be encrypted with keys from your service"
  type        = bool
  default     = true
}

variable "endpoints" {
  description = "Service endpoints for instance and keys"
  type        = string
  default     = "private"
  validation {
    error_message = "Endpoints must be private, public, or public-and-private."
    condition     = contains(["private", "public", "public-and-private"], var.endpoints)
  }
}

##############################################################################

##############################################################################
# Keys
##############################################################################

variable "keys" {
  description = "List of encryption keys to provision"
  type = list(
    object({
      name             = string
      root_key         = bool
      force_delete     = optional(bool)
      rotation         = optional(number)
      dual_auth_delete = bool
    })
  )
  default = []

  validation {
    error_message = "Each key must have a unique name."
    condition = length(
      distinct(
        var.keys[*].name
      )
    ) == length(var.keys[*].name)
  }

  validation {
    error_message = "Rotation must be an integer between 1 and 12."
    condition = length(
      [
        for key in var.keys :
        key if key.rotation % 1 != 0 || key.rotation < 1 || key.rotation > 12
      ]
    ) == 0
  }
}

##############################################################################