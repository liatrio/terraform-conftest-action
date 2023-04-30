# Boilerplate Conftest Logic
package azurerm_naming

import future.keywords.in

deny[msg] {
    rule[x]

	new_resource(x)

    msg := sprintf("[%s] %s %s", [x.code, x.resource.address, x.msg])
}

warn[msg] {
    rule[x]

	not new_resource(x)

    msg := sprintf("[%s] %s %s", [x.code, x.resource.address, x.msg])
}

allow {
	count(deny) == 0
	count(warn) == 0
}


new_resource(x) := true {
	x.resource.change.actions[_] in ["create", "replace"]
}
