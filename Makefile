verify:
	conftest verify -d policy/data/

fmt:
	opa fmt -w policy/*

opa-run: bundle
	opa run \
		--log-level debug  \
		--server \
		--bundle bundle.tar.gz

bundle:
	@rm -rf .bundle/
	@cp -r policy .bundle
	@rm -rf .bundle/data
	find .bundle -name '*_test.rego' -exec rm {} \;
	yq -o=json . policy/data/* | jq --slurp add > .bundle/data.json
	opa build -b .bundle
