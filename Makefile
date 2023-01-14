# CUDA variables to pick the right base image
CUDA_VERSION := 11.7.1
CUDA_FLAVOR := cudnn8-runtime
CUDA_OS := ubuntu22.04
# Python version
PYTHON_VERSION := 3.10
# Names of Jupyter containers in docker-stacks to build
ROOT_CONTAINER := nvidia/cuda:$(CUDA_VERSION)-$(CUDA_FLAVOR)-$(CUDA_OS)
FOUNDATION := docker-stacks-foundation
NOTEBOOKS := base minimal r scipy datascience tensorflow pyspark all-spark
JUPYTER_DOCKER_STACKS := https://raw.githubusercontent.com/jupyter/docker-stacks/master
# docker-jupyter-cuda images to build
FOUNDATION_IMAGE := $(FOUNDATION:%-cuda)
IMAGES := $(FOUNDATION_IMAGE) $(NOTEBOOKS:%=%-notebook-cuda)
# Dockerhub user and tag
USER := kentwait
TAG := cuda$(CUDA_VERSION)-$(CUDA_FLAVOR)-$(CUDA_OS)-py$(PYTHON_VERSION)

# Build variables
CONTEXT = docker-stacks/$(patsubst %-cuda,%,$*)
DOCKERFILE = $(CONTEXT)/Dockerfile
BASE_CONTAINER = $(USER)/$$(awk -F'=' '/ARG BASE_CONTAINER/ {split($$2,s,"/"); print s[2]}' $(DOCKERFILE))-cuda:$(TAG)
COMMAND = docker build \
		--build-arg BASE_CONTAINER=$(BASE_CONTAINER) \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		-t $(USER)/$*-cuda:$(TAG) \
		$(CONTEXT)
# For foundation only
FOUNDATION_CONTEXT = docker-stacks/$(FOUNDATION)
FOUNDATION_COMMAND = docker build \
 --build-arg ROOT_CONTAINER=$(ROOT_CONTAINER) \
 --build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
 -t $(USER)/$(FOUNDATION)-cuda:$(TAG) \
 $(FOUNDATION_CONTEXT)

# foundation image from cuda base
build/docker-stacks-foundation-cuda:
	@echo Building $@ ...
	@echo $(FOUNDATION_COMMAND)
	@$(shell $(FOUNDATION_COMMAND) 2>&1 | tee build.$(FOUNDATION).log) 

# dependencies for build order
build/base-notebook-cuda: build/docker-stacks-foundation-cuda
build/minimal-notebook-cuda: build/base-notebook-cuda
build/r-notebook-cuda: build/minimal-notebook-cuda
build/scipy-notebook-cuda: build/minimal-notebook-cuda
build/datascience-notebook-cuda: build/scipy-notebook-cuda
build/tensorflow-notebook-cuda: build/scipy-notebook-cuda
build/pyspark-notebook-cuda: build/scipy-notebook-cuda
build/all-pyspark-notebook-cuda: build/pyspark-notebook-cuda

# other images
build/%-cuda:
	@echo Building $@
	@echo $(COMMAND)
	@$(shell $(COMMAND) 2>&1 | tee build.$*.log) 
build-all: $(foreach I, $(IMAGES), build/$(I))

# Push to Dockerhub under username $USER
push/%:
	docker push --all-tags $(USER)/$(notdir $@)
push-all: $(foreach I, $(IMAGES), push/$(I))

# Pull from Dockerhub from username $USER
pull/%:
	docker pull $(USER)/$(notdir $@)
pull-all: $(foreach I, $(IMAGES), pull/$(I))

# Returns an error
# ERROR: usage: __main__.py [options] [file_or_dir] [file_or_dir] [...]
# __main__.py: error: unrecognized arguments: --numprocesses /Users/kent/src/docker-jupyter-cuda/docker-stacks/tests/docker-stacks-foundation
# Run tests against a stack
# test/%-cuda: 
# 	cd docker-stacks && \
# 	python3 -m tests.run_tests --short-image-name "$(notdir $*)" --owner "$(USER)"
# test-all: $(foreach I, $(IMAGES), test/$(I))

# Remove images
rm/%:
	docker rmi $(USER)/$(notdir $@)
rm-all: $(foreach I, $(IMAGES), clean/$(I))

# Build all images
.PHONY: all
all: build-all

# Clean up
.PHONY: clean
clean:
	rm -f build.*.log
