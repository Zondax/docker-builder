DOCKER_IMAGE="zondax/docker-optee"

INTERACTIVE:=$(shell [ -t 0 ] && echo 1)

ifdef INTERACTIVE
INTERACTIVE_SETTING:="-i"
TTY_SETTING:="-t"
else
INTERACTIVE_SETTING:=
TTY_SETTING:=
endif

define run_docker
	docker run $(TTY_SETTING) $(INTERACTIVE_SETTING) --rm \
	--privileged \
	-u $(shell id -u):$(shell id -g) \
	-v $(shell pwd):/project \
	-e DISPLAY=$(shell echo ${DISPLAY}) \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	$(DOCKER_IMAGE) \
	"$(1)"
endef

build:
	docker build --rm -f Dockerfile $(TTY_SETTING) $(DOCKER_IMAGE) .

publish:
	docker login
	docker build --rm -f Dockerfile $(TTY_SETTING) $(DOCKER_IMAGE) .
	docker push $(DOCKER_IMAGE)

pull:
	docker pull $(DOCKER_IMAGE)

shell: build
	$(call run_docker,zsh)

test:
	$(call run_docker,xterm)
