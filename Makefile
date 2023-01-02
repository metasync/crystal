include Makefile.env

dev: run.lucky

build.crystal:
	@docker build . -f Dockerfile.crystal -t $(CRYSTAL_IMAGE) \
		--build-arg crystal_release=$(CRYSTAL_RELEASE) \
		--build-arg crystal_build=$(CRYSTAL_BUILD)
run.crystal:
	@docker run --rm -it -v $(PRJ_SRC_PATH):$(WORKDIR) $(CRYSTAL_IMAGE) /bin/sh
build.lucky:
	@docker build . -f Dockerfile.lucky.build-base -t $(LUCKY_IMAGE) \
		--build-arg crystal_release=$(CRYSTAL_RELEASE) \
		--build-arg crystal_build=$(CRYSTAL_BUILD) \
		--build-arg lucky_cli_version=${LUCKY_CLI_VERSION}
run.lucky:
	@docker run --rm -it -v $(PRJ_SRC_PATH):$(WORKDIR) $(LUCKY_IMAGE) /bin/sh
init.app:
	@docker run --rm -it -v $(PRJ_SRC_PATH):$(WORKDIR) $(CRYSTAL_IMAGE) crystal init app $(name)
init.lib:
	@docker run --rm -it -v $(PRJ_SRC_PATH):$(WORKDIR) $(CRYSTAL_IMAGE) crystal init lib $(name)
prune:
	@docker image prune -f
clean: prune

.PHONY: dev build.crystal build.lucky run.crystal run.lucky init.app init.lib prune clean
