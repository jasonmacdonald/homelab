.POSIX:

env ?= "prod"

default: servers cluster

~/.ssh/id_rsa:
	ssh-keygen -t rsa -f "$@"

servers: 
	make -C terraform

cluster:
	ansible-playbook \
		--inventory inventories/${env}.yml \
		cluster.yml

console:
	ansible-console \
		--inventory inventories/${env}.yml
