package main

import data.azure_regions as azure_regions
import data.environments  as environments

import data.mandatory_tags as mandatory_tags_list
import future.keywords.in
import input as tfplan

azure_hyphen_types := {
    "azurerm_resource_group": "rg",
    "azurerm_virtual_network": "vnet",
    "azurerm_subnet": "snet",
    "azurerm_network_security_group": "nsg",
    "azurerm_virtual_machine": "vm",
    "azurerm_linux_virtual_machine": "vm",
    "azurerm_windows_virtual_machine": "vm",
    "azurerm_managed_disk": "disk"
}


# Check resource type, e.g. `vnet-`, `vm-`, `rg-`, etc
# <type>-<env>-<region>-<project>-<description>
not_allow[msg] {
	deny_azurerm_resource_name_prefix[msg]
}
deny_azurerm_resource_name_prefix[msg] {
	resource := tfplan.resource_changes[_]
	name :=  resource.change.after.name
    startswith(name, "azurerm_")
    arr := split(name, "-")
    prefix := azure_hyphen_types[resource.type]
    arr[0] != prefix

    msg := sprintf("Resource %s has wrong prefix: %s, expected %s", [resource.address, arr[0], prefix])
}

# Check resource `env` from known list
# <type>-<env>-<region>-<project>-<description>
not_allow[msg] {
    deny_azurerm_resource_name_env[msg]
}
deny_azurerm_resource_name_env[msg] {
	resource := tfplan.resource_changes[_]
	name :=  resource.change.after.name
    startswith(name, "azurerm_")
    arr := split(name, "-")
    env := arr[1]
    not env in environments

    msg := sprintf("Resource %s has unknown environment: %s, not in %v", [resource.address, env, environments])
}

# Check resource `region` from known list
# <type>-<env>-<region>-<project>-<description>
not_allow[msg] {
    deny_azurerm_resource_name_region[msg]
}
deny_azurerm_resource_name_region[msg] {
	resource := tfplan.resource_changes[_]
	name :=  resource.change.after.name
    startswith(name, "azurerm_")
    arr := split(name, "-")
    region := arr[2]
    not region in azure_regions

    msg := sprintf("Resource %s has unknown region: %s, not in %v", [resource.address, region, azure_regions])
}

# Check number of items in name.split('-'), to match
# <type>-<env>-<region>-<project>-<description>
not_allow[msg] {
    deny_azurerm_resource_name_format[msg]
}
deny_azurerm_resource_name_format[msg] {
	resource := tfplan.resource_changes[_]
	name :=  resource.change.after.name
    startswith(name, "azurerm_")
    arr := split(name, "-")
    count(arr) != 5

    msg := sprintf("Resource %s has unknown name format: %s, expected <type>-<env>-<region>-<project>-<description>", [resource.address, name])
}

# Storage Account Specific: Start with sto
# sto{env}{region}{project}{description}
not_allow[msg] {
    deny_azurerm_sto_prefix[msg]
}
deny_azurerm_sto_prefix[msg] {
	resource := tfplan.resource_changes[_]
	name :=  resource.change.after.name
    resource.type == "azurerm_storage_account"
    not startswith(name, "sto")
    msg := sprintf("Storage Account %s name %s doesn't follow the format 'sto{environment}{region}{project}{description}' (doesn't start with sto)", [resource.address, name])
}

# Storage Account Specific: Start with sto{env}
# sto{env}{region}{project}{description}
not_allow[msg] {
    deny_azurerm_sto_env[msg]
}
deny_azurerm_sto_env[msg] {
	resource := tfplan.resource_changes[_]
	name :=  resource.change.after.name
    resource.type == "azurerm_storage_account"
    startswith(name, "sto")
    name_no_prefix := substring(name, count("sto"), -1)
    
    # No environment is a prefix to the resource
    count({ x | x = environments[_]; startswith(name_no_prefix, x)}) == 0

    msg := sprintf("Storage Account %s name %s doesn't follow the format 'sto{environment}{region}{project}{description}' (unknown environment)", [resource.address, name])
}

# Storage Account Specific: Start with sto{env}{region}
# sto{env}{region}{project}{description}
not_allow[msg] {
    deny_azurerm_sto_region[msg]
}
deny_azurerm_sto_region[msg] {
	resource := tfplan.resource_changes[_]
	name :=  resource.change.after.name
    resource.type == "azurerm_storage_account"
    startswith(name, "sto")
    name_no_prefix := substring(name, count("sto"), -1)
    
    # No environment is a prefix to the resource
    env := environments[_]
    startswith(name_no_prefix, env)
    name_no_env := substring(name_no_prefix, count(env), -1)

    # No environment is a prefix to the resource
    count({ x | x = azure_regions[_]; startswith(name_no_env, x)}) == 0

    msg := sprintf("Storage Account %s name %s doesn't follow the format 'sto{environment}{region}{project}{description}' (env=%s, unknown region)", [resource.address, name, env])
}
