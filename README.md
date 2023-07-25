# Key Management Module

This module allows users to:
- Create a new a Key Protect Instance
  - Users can optionally choose to use an existing Key Management Service, Key Protect or HPCS (*HPCS must be set up manually*)
- Create any number of encryption keys and policies for those keys
- Create permissions needed to allow VPC block storage volumes to be encrypted with keys stored as part of the key management service.


## Environment Variables

The following variables are needed to provision the key management resources for this module.

Name                    | Type                                                                                                                                | Description                                                                                  | Default
----------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------
resource_group_id       | string                                                                                                                              | ID for the resource group where resources will be created                                    | 
region                  | string                                                                                                                              | IBM Cloud Region where resources will be provisioned                                         | 

## Instance Variables

These variables are used to configure the key management resource, as well as keys and service authrorizations.

Name                    | Type                                                                                                                                | Description                                                                                  | Default
----------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------
prefix                  | string                                                                                                                              | Name prefix that will be prepended to named resources                                        | 
create                  | bool                                                                                                                                | Create a Key Protect instance for keys                                                       | `true`
name                    | string                                                                                                                              | Name of the key management service instance                                                  | `kms`
hpcs                    | bool                                                                                                                                | Use an existing HPCS instance to create encryption keys                                      | `false`
create_vpc_storage_auth | bool                                                                                                                                | Create IAM policies to allow VSI storage volumes to be encrypted with keys from your service | `true`
endpoints               | string                                                                                                                              | Service endpoints for instance and keys. Can be `public`, `private`, or `public-and-private` | `private`
tags                    | list(string)                                                                                                                        | List of tags                                                                                 | 
keys                    | list( object({ name = string root_key = bool force_delete = optional(bool) rotation = optional(number) dual_auth_delete = bool }) ) | List of encryption keys to provision                                                         | `[]`

## Outputs

Name    | Description 
------- | ------------
id      | Service ID  
guid    | Service GUID
keys    | List of keys
key_map | Map of keys 

## Example Usage

A template showing example usage of this module can be found [here](./tests/example_module).

## Acceptance Tests

This module uses [tfxjs]() to run example tests. Tests can be found in the [tests](./tests) directory.