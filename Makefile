.PHONY: apply check fmt plan validate

.DEFAULT_GOAL := test

check:
	tofu fmt -check

fmt:
	tofu fmt

validate:
	tofu validate

plan:
	tofu plan -out=plan.tfplan

apply:
	tofu apply plan.tfplan
	rm plan.tfplan

test: check validate
