# Terraform conftest
A collection of [rego](https://www.openpolicyagent.org/docs/latest/policy-language/) policies which can be used to validate terraform plan json.

Assuming you have the ability to capture a plan as json:

`conftest test -d policy/data plan.json`

Or, with `docker`,

``` sh
docker build . -t terraform-conftest
docker run -i terraform-conftest test - < plan.json
```

## Running a subset of tests

The tests are broken out into `namespaces`, such as `azurerm_naming` and `azurerm_tagging`. These are the `package` names in the rego files. The `conftest.toml` file mentions `--all-namespaces`, so that by default all namespaces are used. If you want to test specific functionality, you can override this with `--all-namespaces=false --namespace=<your namespace>`. For example:

```sh
docker run -i terraform-conftest test --all-namespaces=false --namespace azurerm_naming - < ./plan.json
```

# Developer Guide: Adding a new set of tests

We have four problems to handle:

1. New Terraform resources v.s. existing resources. They have a different structure
2. The `deny` syntax is hard to unit test, the `deny_` syntax is error prone because then `count(deny) == 0` doesn't work, and you need to track every rule.
3. We want to `warn` v.s. `deny` depending on whether these are old v.s. new resources, using the same rules
4. We want to be able to independently test each `package/namespace`.

## `import data.tfplan`
To solve `(1)` we use a shared `tfplan` module. Use `import data.tfplan`. 

## The `rule` set

To solve `(2)`, we create a `rule[x]` set, where `x` is a dictionary: `{"code": "useful name", "resource": <the terraform resource>, "msg": "The useful error message"}`. This gives us the best of both worlds. We can unit-test using `x.code` to check specific violations, OR we can check if the `rule` set is empty. We use this for ALL rules, and then a helper file formats them into `warn` or `deny` statements.

## warn v.s. deny

At the moment we warn on existing resources and deny new resources. This is found in the "helper" boilerplate found in the `*_z.rego` files. Every package has to have one of these, even if they're all basically the same. I couldn't figure out how to inherit/import them effectively.

## independently test each namespace

This is the second reason for having the `*_z.rego` files in every package. They allow each to function standalone. The alternative I tried before was having the helper logic in a `main` package, which imported all of the sub-packages, but then you couldn't test them independently.
