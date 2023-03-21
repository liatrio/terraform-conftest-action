package main

test_cost_center {
	cfg := parse_config_file("../tests/cost_center_typo/plan.json")
	deny with input as cfg
}

test_missing_tag {
	cfg := parse_config_file("../tests/missing_tag/plan.json")
	deny with input as cfg
}

test_automation_enabled_yesno {
	cfg := parse_config_file("../tests/automation_enabled_yesno/plan.json")
	deny with input as cfg
}
