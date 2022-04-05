.POSIX:

env ?= "prod"

default: servers cluster

~/.ssh/id_rsa:
	ssh-keygen -t rsa -f "$@"

servers: 
	make -C terraform

boot: ~/.ssh/id_rsa
	ansible-playbook \
		--inventory inventories/${env}.yml \
		boot.yml

cluster:
	ansible-playbook \
		--inventory inventories/${env}.yml \
		cluster.yml

console:
	ansible-console \
		--inventory inventories/${env}.yml
