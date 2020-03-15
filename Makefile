DOCKER_IMAGE_PREFIX=zondax/builder
DOCKER_IMAGE_BASE=${DOCKER_IMAGE_PREFIX}-base
DOCKER_IMAGE_QEMUV7=${DOCKER_IMAGE_PREFIX}-qemuv7
DOCKER_IMAGE_QEMUV8=${DOCKER_IMAGE_PREFIX}-qemuv8
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
	cd qemuv7  && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_QEMUV7) .
	cd qemuv8  && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_QEMUV8) .

publish: build
	docker login
	docker push $(DOCKER_IMAGE_BASE)
	docker push $(DOCKER_IMAGE_YOCTO)
	docker push $(DOCKER_IMAGE_QEMUV7)
	docker push $(DOCKER_IMAGE_QEMUV8)

pull:
	docker pull $(DOCKER_IMAGE_BASE)
	docker pull $(DOCKER_IMAGE_YOCTO)
	docker pull $(DOCKER_IMAGE_QEMUV7)
	docker pull $(DOCKER_IMAGE_QEMUV8)

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

shell_qemuv7: build
	$(call run_docker,$(DOCKER_IMAGE_QEMUV7),zsh)

shell_qemuv8: build
	$(call run_docker,$(DOCKER_IMAGE_QEMUV8),zsh)
