.POSIX:

default: metal bootstrap 

all: metal bootstrap external 

configure:
	./scripts/configure
	git status

.PHONY: metal
metal:
	make -C metal

.PHONY: bootstrap
bootstrap:
	make -C bootstrap

.PHONY: external
external:
	make -C external

wait:
	./scripts/wait-main-apps

.PHONY: tools
tools:
	make -C tools

