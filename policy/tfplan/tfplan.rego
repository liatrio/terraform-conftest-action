package tfplan

import input
import future.keywords.in

#default changes := []
#changes := x {
#    x := input.resource_changes
#}

# Resource Changes that cause a create
creations[x] {
    y := input.resource_changes[_]
    y.change.actions[_] in ["create", "replace"]

    x := object.union(y, {"values": y.change.after})
}

# All other changes
resources[x] {
    y := input.resource_changes[_]
    #not "create" in y.change.actions
    #not "replace" in y.change.actions

    x := object.union(y, {"values": y.change.after})
}

# Root Module
resources[x] {
    x := input.values.root_module.resources[_]
}

# Child Modules
resources[x] {
    children := input.values.root_module.child_modules
    module := children[_]

    x := module.resources[_]
}
