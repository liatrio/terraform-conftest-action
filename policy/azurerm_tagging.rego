package azurerm_tagging

import data.cost_centers as cost_centers
import data.mandatory_tags as mandatory_tags_list
import future.keywords.in

import data.tfplan as tfplan

# Convert the list to a set
mandatory_tags := {x | x = mandatory_tags_list[_]}

rule[{"code": "missing", "resource": resource, "msg": msg}] {
	resource := tfplan.resources[_]
    resource.values.tags

	resource_tags := {t | some t; resource.values.tags[t]}
	missing_tags := mandatory_tags - resource_tags
	count(missing_tags) > 0

	msg := sprintf("is missing tags: %s", [missing_tags])
}

rule[{"code": "cost_center", "resource": resource, "msg": msg}] {
	resource := tfplan.resources[_]
	cost_center := resource.values.tags.CostCenter
	not cost_center in cost_centers

	msg := sprintf("has unknown CostCenter: %s not in %v", [cost_center, cost_centers])
}

rule[{"code": "automation_enabled", "resource": resource, "msg": msg}] {
	resource := tfplan.resources[_]
	yn := resource.values.tags.AutomationEnabled
	not yn in ["yes", "no"]

	msg := sprintf("has unknown AutomationEnabled value: %s. Should be 'yes' or 'no'", [yn])
}
