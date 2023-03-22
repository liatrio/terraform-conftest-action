# Terraform conftest
A collection of [rego](https://www.openpolicyagent.org/docs/latest/policy-language/) policies which can be used to validate terraform plan json.

Assuming you have the ability to capture a plan as json:

`conftest test -d policy/data plan.json`

Or, with `docker`,

``` sh
docker build . -t terraform-conftest
docker run terraform-conftest test - < plan.json
```
