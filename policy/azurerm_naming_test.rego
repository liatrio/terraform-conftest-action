package azurerm_naming

test_valid_naming {
	cfg := parse_config_file("../tests/valid_azurerm_naming/plan.json")
	count(rule) == 0 with input as cfg
}

# Regular Resources
test_deny_prefix {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "prefix"
}

test_deny_env {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "env"
}

test_deny_region {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
    rules := rule with input as cfg
	rules[x]
	x.code == "region"
}

test_deny_format {
	cfg := parse_config_file("../tests/azurerm_bad_naming/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "format"
}

# Storage Accounts
test_deny_azurerm_sto_prefix {
	cfg := parse_config_file("../tests/azurerm_bad_sto_naming/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "sto_prefix"
}

test_deny_azurerm_sto_env {
	cfg := parse_config_file("../tests/azurerm_bad_sto_naming/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "sto_env"
}

test_deny_azurerm_sto_region {
	cfg := parse_config_file("../tests/azurerm_bad_sto_naming/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "sto_region"
}
