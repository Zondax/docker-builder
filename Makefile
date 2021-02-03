DOCKER_IMAGE_PREFIX=zondax/builder
DOCKER_IMAGE_BASE=${DOCKER_IMAGE_PREFIX}-base
DOCKER_IMAGE_YOCTO=${DOCKER_IMAGE_PREFIX}-yocto
DOCKER_IMAGE_BOLOS=${DOCKER_IMAGE_PREFIX}-bolos
DOCKER_IMAGE_ZEMU=${DOCKER_IMAGE_PREFIX}-zemu
DOCKER_IMAGE_CIRCLECI=zondax/circleci
DOCKER_IMAGE_RUSTCI=zondax/rust-ci

INTERACTIVE:=$(shell [ -t 0 ] && echo 1)

ifdef INTERACTIVE
INTERACTIVE_SETTING:="-i"
TTY_SETTING:="-t"
else
INTERACTIVE_SETTING:=
TTY_SETTING:=
endif

default: build

build: build_base build_yocto build_bolos \
       build_zemu build_circleci build_rustci

build_base:
	cd base && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_BASE) .
build_yocto:
	cd yocto && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_YOCTO) .
build_bolos:
	cd bolos && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_BOLOS) .
build_zemu:
	cd zemu && docker build -f Dockerfile -t $(DOCKER_IMAGE_ZEMU) .
build_circleci:
	cd circleci && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_CIRCLECI) .
build_rustci:
	cd rust-ci && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_RUSTCI) .

publish_login:
	docker login
publish_base: build_base
	docker push $(DOCKER_IMAGE_BASE)
publish_yocto: build_yocto
	docker push $(DOCKER_IMAGE_YOCTO)
publish_bolos: build_bolos
	docker push $(DOCKER_IMAGE_BOLOS)
publish_zemu: build_zemu
	docker push $(DOCKER_IMAGE_ZEMU)
publish_circleci: build_circleci
	docker push $(DOCKER_IMAGE_CIRCLECI)
publish_rustci: build_rustci
	docker push $(DOCKER_IMAGE_RUSTCI)

publish: build
publish: publish_login
publish: publish_base
publish: publish_yocto
publish: publish_bolos
publish: publish_zemu
publish: publish_circleci
publish: publish_rustci

pull:
	docker pull $(DOCKER_IMAGE_BASE)
	docker pull $(DOCKER_IMAGE_YOCTO)
	docker pull $(DOCKER_IMAGE_BOLOS)
	docker pull $(DOCKER_IMAGE_ZEMU)
	docker pull $(DOCKER_IMAGE_CIRCLECI)
	docker pull $(DOCKER_IMAGE_RUSTCI)

define run_docker
	docker run $(TTY_SETTING) $(INTERACTIVE_SETTING) \
	--privileged \
	-u $(shell id -u):$(shell id -g) \
	-v $(shell pwd):/project \
	-e DISPLAY=$(shell echo ${DISPLAY}) \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	$(1) \
	"$(2)"
endef

shell_base: build_base
	$(call run_docker,$(DOCKER_IMAGE_BASE),zsh)

shell_yocto: build_yocto
	$(call run_docker,$(DOCKER_IMAGE_YOCTO),zsh)

shell_bolos: build_bolos
	$(call run_docker,$(DOCKER_IMAGE_BOLOS),/bin/bash)

shell_zemu: build_zemu
	$(call run_docker,$(DOCKER_IMAGE_ZEMU),/bin/bash)

shell_circleci: build_circleci
	$(call run_docker,$(DOCKER_IMAGE_CIRCLECI),/bin/bash)

shell_rust-ci: build_rustci
	$(call run_docker,$(DOCKER_IMAGE_RUSTCI),/bin/bash)
