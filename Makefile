.PHONY: all help build buildswarm clean

user = $(shell whoami)
ifeq ($(user),root)
$(error  "do not run as root! run 'gpasswd -a USER docker' on the user of your choice")
endif

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make build       - build and run docker swarm locally from vbox
	@echo ""   2. make clean       - destroy and clean docker swarm locally from vbox

build: NAME TAG buildswarm

buildswarm: local swarmID swarm-master node00 node01 info

local:
	docker-machine create -d virtualbox local
	docker-machine env local
	touch local

swarmID:
	$(eval DOCKER_ENV := $(shell docker-machine env local|sed 's/export//g'))
	$(eval SWARM_ID := $(shell $(DOCKER_ENV) docker run swarm create)) 
	@echo $(SWARM_ID) |tee swarmID

swarm-master:
	$(eval SWARM_ID := $(shell cat swarmID))
	docker-machine create \
	-d virtualbox \
	--swarm \
	--swarm-master \
	--swarm-discovery token://$(SWARM_ID) \
	swarm-master
	@touch swarm-master

node00:
	$(eval SWARM_ID := $(shell cat swarmID))
	docker-machine create \
	-d virtualbox \
	--swarm \
	--swarm-discovery token://$(SWARM_ID) \
	swarm-agent-00
	@touch node00

node01:
	$(eval SWARM_ID := $(shell cat swarmID))
	docker-machine create \
	-d virtualbox \
	--swarm \
	--swarm-discovery token://$(SWARM_ID) \
	swarm-agent-01
	@touch node01

env:
	docker-machine env --swarm swarm-master

localenv:
	docker-machine env local

info:
	$(eval DOCKER_ENV := $(shell docker-machine env --swarm swarm-master|sed 's/export//g'))
	$(DOCKER_ENV) docker info
	$(DOCKER_ENV) docker ps -a

hello-world: helloworld

helloworld:
	$(eval DOCKER_ENV := $(shell docker-machine env --swarm swarm-master|sed 's/export//g'))
	$(DOCKER_ENV) docker run hello-world

clean:
	-docker-machine rm swarm-agent-01
	-rm node01
	-docker-machine rm swarm-agent-00
	-rm node00
	-docker-machine rm swarm-master
	-rm swarm-master
	-docker-machine rm local
	-rm local
	-rm swarmID

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;
