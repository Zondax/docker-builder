DOCKER_IMAGE_PREFIX=zondax/builder
DOCKER_IMAGE_BASE=${DOCKER_IMAGE_PREFIX}-base
DOCKER_IMAGE_QEMU=${DOCKER_IMAGE_PREFIX}-qemu
DOCKER_IMAGE_YOCTO=${DOCKER_IMAGE_PREFIX}-yocto

INTERACTIVE:=$(shell [ -t 0 ] && echo 1)

ifdef INTERACTIVE
INTERACTIVE_SETTING:="-i"
TTY_SETTING:="-t"
else
INTERACTIVE_SETTING:=
TTY_SETTING:=
endif

default: build

build:
	cd base  && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_BASE) .
	cd yocto && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_YOCTO) .
#	cd qemu  && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_QEMU) .

publish: build
	docker login
	docker push $(DOCKER_IMAGE_BASE)
	docker push $(DOCKER_IMAGE_YOCTO)
	# docker push $(DOCKER_IMAGE_QEMU)

pull:
	docker pull $(DOCKER_IMAGE_BASE)
	# docker pull $(DOCKER_IMAGE_QEMU)
	# docker pull $(DOCKER_IMAGE_YOCTO)

define run_docker
	docker run $(TTY_SETTING) $(INTERACTIVE_SETTING) --rm \
	--privileged \
	-u $(shell id -u):$(shell id -g) \
	-v $(shell pwd):/project \
	-e DISPLAY=$(shell echo ${DISPLAY}) \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	$(1) \
	"$(2)"
endef

shell_base: build
	$(call run_docker,$(DOCKER_IMAGE_BASE),zsh)

shell_yocto: build
	$(call run_docker,$(DOCKER_IMAGE_YOCTO),zsh)

shell_qemu: build
	$(call run_docker,$(DOCKER_IMAGE_QEMU),zsh)
