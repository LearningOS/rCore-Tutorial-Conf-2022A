HOST_DIR ?= $(shell pwd)

.PHONY: docker
docker:
	HOST_DIR=$(HOST_DIR) $(MAKE) -C docker user

.PHONY: clean-docker
clean-docker:
	$(MAKE) -C docker clean
