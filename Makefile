DOCKER_IMAGE="zondax/docker-optee"

define run_docker
	docker run -it --rm \
	--privileged \
	-u $(shell id -u) \
	-v $(shell pwd):/project \
	-e DISPLAY=$(shell echo ${DISPLAY}) \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	$(DOCKER_IMAGE) \
	"$(1)"
endef

build:
	docker build --rm -f Dockerfile -t $(DOCKER_IMAGE) .

publish:
	docker login
	docker build --rm -f Dockerfile -t $(DOCKER_IMAGE) .
	docker push $(DOCKER_IMAGE)

pull:
	docker pull $(DOCKER_IMAGE)

shell:
	$(call run_docker,bash)
