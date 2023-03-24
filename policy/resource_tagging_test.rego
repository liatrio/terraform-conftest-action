package main

test_valid_tags {
	cfg := parse_config_file("../tests/valid_tags/plan.json")
	allow with input as cfg
}

test_cost_center {
	cfg := parse_config_file("../tests/cost_center_typo/plan.json")
	deny_cost_center[msg] with input as cfg
}

test_missing_tags {
	cfg := parse_config_file("../tests/missing_tag/plan.json")
	deny_missing_tags[msg] with input as cfg
}

test_automation_enabled_yesno {
	cfg := parse_config_file("../tests/automation_enabled_yesno/plan.json")
	deny_automation_enabled_yesno[msg] with input as cfg
}
