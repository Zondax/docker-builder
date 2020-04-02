DOCKER_IMAGE_PREFIX=zondax/builder
DOCKER_IMAGE_BASE=${DOCKER_IMAGE_PREFIX}-base
DOCKER_IMAGE_QEMUV7=${DOCKER_IMAGE_PREFIX}-qemuv7
DOCKER_IMAGE_QEMUV8=${DOCKER_IMAGE_PREFIX}-qemuv8
DOCKER_IMAGE_YOCTO=${DOCKER_IMAGE_PREFIX}-yocto
DOCKER_IMAGE_BOLOS_EMU=${DOCKER_IMAGE_PREFIX}-bolos-emu
DOCKER_IMAGE_BOLOS=${DOCKER_IMAGE_PREFIX}-bolos
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

build: build_base build_yocto build_qemuv7 build_qemuv8 build_bolos \
       build_bolos_emu build_circleci build_rustci

build_base:
	cd base && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_BASE) .
build_yocto:
	cd yocto && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_YOCTO) .
build_qemuv7:
	cd qemuv7 && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_QEMUV7) .
build_qemuv8:
	cd qemuv8 && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_QEMUV8) .
build_bolos:
	cd bolos && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_BOLOS) .
build_bolos_emu:
	cd bolos-emu && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_BOLOS_EMU) .
build_circleci:
	cd circleci && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_CIRCLECI) .
build_rustci:
	cd rust-ci && docker build --rm -f Dockerfile -t $(DOCKER_IMAGE_RUSTCI) .

publish: build
	docker login
	docker push $(DOCKER_IMAGE_BASE)
	docker push $(DOCKER_IMAGE_YOCTO)
	docker push $(DOCKER_IMAGE_QEMUV7)
	docker push $(DOCKER_IMAGE_QEMUV8)
	docker push $(DOCKER_IMAGE_BOLOS)
	docker push $(DOCKER_IMAGE_BOLOS_EMU)
	docker push $(DOCKER_IMAGE_CIRCLECI)
	docker push $(DOCKER_IMAGE_RUSTCI)

pull:
	docker pull $(DOCKER_IMAGE_BASE)
	docker pull $(DOCKER_IMAGE_YOCTO)
	docker pull $(DOCKER_IMAGE_QEMUV7)
	docker pull $(DOCKER_IMAGE_QEMUV8)
	docker pull $(DOCKER_IMAGE_BOLOS)
	docker pull $(DOCKER_IMAGE_BOLOS_EMU)
	docker pull $(DOCKER_IMAGE_CIRCLECI)
	docker pull $(DOCKER_IMAGE_RUSTCI)

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

shell_base: build_base
	$(call run_docker,$(DOCKER_IMAGE_BASE),zsh)

shell_yocto: build_yocto
	$(call run_docker,$(DOCKER_IMAGE_YOCTO),zsh)

shell_qemuv7: build_qemuv7
	$(call run_docker,$(DOCKER_IMAGE_QEMUV7),zsh)

shell_qemuv8: build_qemuv8
	$(call run_docker,$(DOCKER_IMAGE_QEMUV8),zsh)

shell_bolos: build_bolos
	$(call run_docker,$(DOCKER_IMAGE_BOLOS),/bin/bash)

shell_bolos_emu: build_bolos_emu
	$(call run_docker,$(DOCKER_IMAGE_BOLOS_EMU),/bin/bash)

shell_circleci: build_circleci
	$(call run_docker,$(DOCKER_IMAGE_CIRCLECI),/bin/bash)

shell_rust-ci: build_rustci
	$(call run_docker,$(DOCKER_IMAGE_RUSTCI),/bin/bash)
