.PHONY: apply check fmt plan validate

.DEFAULT_GOAL := test

check:
	terraform fmt -check

fmt:
	terraform fmt

validate:
	terraform validate

plan:
	terraform plan -out=plan.tfplan

apply:
	terraform apply plan.tfplan
	rm plan.tfplan

test: check validate
