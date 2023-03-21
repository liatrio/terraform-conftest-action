package main

import input as tfplan

mandatory_tags := {
	"Owner",
	"CostCenter",
	"AutomationEnabled",
}

deny[msg] {
	resource := tfplan.resource_changes[_]
	resource_tags := {t | some t; resource.change.after.tags[t]}
	missing_tags := mandatory_tags - resource_tags
	count(missing_tags) > 0

	msg := sprintf("resource %v is missing tags: %s", [resource.address, missing_tags])
}
