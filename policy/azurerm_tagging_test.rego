package azurerm_tagging

test_valid_tags {
	cfg := parse_config_file("../tests/valid_tags/plan.json")
	count(rule) == 0 with input as cfg
}

test_cost_center {
	cfg := parse_config_file("../tests/cost_center_typo/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "cost_center"
}

test_missing_tags {
	cfg := parse_config_file("../tests/missing_tag/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "missing"
}

test_automation_enabled_yesno {
	cfg := parse_config_file("../tests/automation_enabled_yesno/plan.json")
	rules := rule with input as cfg
	rules[x]
	x.code == "automation_enabled"
}
