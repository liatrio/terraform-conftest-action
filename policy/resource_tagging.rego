package main

import data.cost_centers as cost_centers
import future.keywords.in
import input as tfplan

mandatory_tags := {
	"Owner",
	"CostCenter",
	"AutomationEnabled",
}

allow {
    deny == set()
}

# This DOES NOT WORK
# allow {
#     not deny
# }

# Missing Tags
deny[msg] {
    deny_missing_tags[msg]
}

deny_missing_tags[msg] {
	resource := tfplan.resource_changes[_]
	resource_tags := {t | some t; resource.change.after.tags[t]}
	missing_tags := mandatory_tags - resource_tags
	count(missing_tags) > 0

	msg := sprintf("resource %v is missing tags: %s", [resource.address, missing_tags])
}


# Cost Center
deny[msg] {
    deny_cost_center[msg]
}

deny_cost_center[msg] {
	resource := tfplan.resource_changes[_]
	cost_center := resource.change.after.tags.CostCenter
	not cost_center in cost_centers

	msg := sprintf("resource %v has unknown CostCenter: %s not in %v", [resource.address, cost_center, cost_centers])
}

# Automation
deny[msg] {
    deny_automation_enabled_yesno[msg]
}

deny_automation_enabled_yesno[msg] {
	resource := tfplan.resource_changes[_]
	yn := resource.change.after.tags["AutomationEnabled"]
	not yn in ["yes", "no"]

	msg := sprintf("resource %v has unknown AutomationEnabled value: %s. Should be 'yes' or 'no'", [resource.address, yn])
}
