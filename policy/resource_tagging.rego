package main

import data.cost_centers as cost_centers
import future.keywords.in
import input as tfplan

mandatory_tags := {
	"Owner",
	"CostCenter",
	"AutomationEnabled",
}

# Missing Tags
deny[msg] {
	resource := tfplan.resource_changes[_]
	resource_tags := {t | some t; resource.change.after.tags[t]}
	missing_tags := mandatory_tags - resource_tags
	count(missing_tags) > 0

	msg := sprintf("resource %v is missing tags: %s", [resource.address, missing_tags])
}

# Cost Center
deny[msg] {
	resource := tfplan.resource_changes[_]
	cost_center := resource.change.after.tags.CostCenter
	not is_valid_cost_center(cost_center)

	msg := sprintf("resource %v has unknown CostCenter: %s not in %v", [resource.address, cost_center, cost_centers])
}

is_valid_cost_center(x) {
	x == cost_centers[_]
}

# Automation
deny[msg] {
	resource := tfplan.resource_changes[_]
	yn := resource.change.after.tags.AutomationEnabled
	not yn in ["yes", "no"]

	msg := sprintf("resource %v has unknown AutomationEnabled value: %s. Should be 'yes' or 'no'", [resource.address, yn])
}
