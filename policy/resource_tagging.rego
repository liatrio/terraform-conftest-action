package main

import data.cost_centers as cost_centers
import data.mandatory_tags as mandatory_tags_list
import future.keywords.in
import input as tfplan

# Convert the list to a set
mandatory_tags := {x | x = mandatory_tags_list[_]}

# This DOES NOT WORK
# allow {
#     not deny
# }

# Missing Tags
not_allow[msg] {
	warn_missing_tags[msg]
}

warn_missing_tags[msg] {
	resource := tfplan.resource_changes[_]
    resource.change.after.tags
	resource_tags := {t | some t; resource.change.after.tags[t]}
	missing_tags := mandatory_tags - resource_tags
	count(missing_tags) > 0

	msg := sprintf("resource %v is missing tags: %s", [resource.address, missing_tags])
}

# Cost Center
not_allow[msg] {
	warn_cost_center[msg]
}

warn_cost_center[msg] {
	resource := tfplan.resource_changes[_]
	cost_center := resource.change.after.tags.CostCenter
	not cost_center in cost_centers

	msg := sprintf("resource %v has unknown CostCenter: %s not in %v", [resource.address, cost_center, cost_centers])
}

# Automation
not_allow[msg] {
	warn_automation_enabled_yesno[msg]
}

warn_automation_enabled_yesno[msg] {
	resource := tfplan.resource_changes[_]
	yn := resource.change.after.tags.AutomationEnabled
	not yn in ["yes", "no"]

	msg := sprintf("resource %v has unknown AutomationEnabled value: %s. Should be 'yes' or 'no'", [resource.address, yn])
}
