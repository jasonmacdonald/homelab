.POSIX:

default: apply

all: plan apply

~/.terraform.d/credentials.tfrc.json: 
	terraform login

terraform.auto.tfvars:
	ansible-playbook tfvars.yml

.terraform.lock.hcl: ~/.terraform.d/credentials.tfrc.json versions.tf terraform.auto.tfvars
	terraform init
	touch .terraform.lock.hcl

plan: .terraform.lock.hcl
	terraform plan 

apply: .terraform.lock.hcl
	terraform apply -auto-approve

destroy: .terraform.lock.hcl
	terraform destroy -auto-approve