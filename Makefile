.PHONY: apply check fmt plan validate

.DEFAULT_GOAL := test

check:
	terraform fmt -check

fmt:
	terraform fmt

validate:
	terraform validate

plan.tfplan:
	terraform plan -out=$@

plan: plan.tfplan

apply:
	terraform apply plan.tfplan

test: check validate
