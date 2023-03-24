package main

test_valid_naming {
	cfg := parse_config_file("../tests/valid_azurerm_naming/plan.json")
	allow with input as cfg
}

# Regular Resources
test_deny_azurerm_resource_name_prefix {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
	deny_azurerm_resource_name_prefix with input as cfg
}

test_deny_azurerm_resource_name_env {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
	deny_azurerm_resource_name_env with input as cfg
}

test_deny_azurerm_resource_name_region {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
	deny_azurerm_resource_name_region with input as cfg
}

test_deny_azurerm_resource_name_format {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
	deny_azurerm_resource_name_format with input as cfg
}

# Storage Accounts
test_deny_azurerm_sto_prefix {
	cfg := parse_config_file("../tests/azurerm_bad_sto_naming/plan.json")
	deny_azurerm_sto_prefix with input as cfg
}

test_deny_azurerm_sto_env {
	cfg := parse_config_file("../tests/azurerm_bad_sto_naming/plan.json")
	deny_azurerm_sto_env with input as cfg
}

test_deny_azurerm_sto_region {
	cfg := parse_config_file("../tests/azurerm_bad_sto_naming/plan.json")
	deny_azurerm_sto_region with input as cfg
}
