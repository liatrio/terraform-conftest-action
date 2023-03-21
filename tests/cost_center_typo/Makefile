plan.json: plan.out
	terraform show -json $< | jq . > $@

plan.out: *.tf
	terraform init
	terraform plan -out $@


