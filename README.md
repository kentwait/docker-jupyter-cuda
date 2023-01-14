# Jupyter Notebook Containers with CUDA Support

This repository contains a `Makefile` that can be used to build and push Jupyter notebook containers that include support for NVIDIA CUDA, using the [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) project.

## Prerequisites

- [Docker](https://www.docker.com/)
- [Make](https://www.gnu.org/software/make/)
- Access to a Dockerhub account for pushing the images

## Getting Started

1. Clone this repository

```bash
git clone https://github.com/kentwait/docker-jupyter-cuda.git
```

2. Open the Makefile and edit the following variables at the top of the Makefile to match your desired configuration:

```bash
CUDA_VERSION := 11.7.1
CUDA_FLAVOR := cudnn8-runtime
CUDA_OS := ubuntu22.04
PYTHON_VERSION := 3.10
```

3. Run make to build the images
```bash
make build-all
```

4. Run make to push the images to your Dockerhub account

```bash
make push-all
```

## Targets
The following `make` targets are available:

- `docker-stacks`: clones the Jupyter Docker Stacks repository from GitHub
- `build/docker-stacks-foundation-cuda`: builds the foundation image with CUDA support
- `build/%-cuda`: builds the specified image with CUDA support
- `build-all`: builds all images with CUDA support
- `push/%`: pushes the specified image to Dockerhub
- `push-all`: pushes all images to Dockerhub

