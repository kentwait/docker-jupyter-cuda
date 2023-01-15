# Jupyter Notebook Containers with CUDA Support

This repository contains a `Makefile` that can be used to build and push Jupyter notebook containers that include support for NVIDIA CUDA, using the [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) project.

## Download from Dockerhub

```
docker pull kentwait/<image-name>:<tag>
```

The following image and tags are currently available from Dockerhub. 

### CUDA 12.0.0 `runtime` image

- `base-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `minimal-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `r-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `scipy-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `datascience-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `tensorflow-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `pytorch-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `pyspark-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`
- `all-spark-notebook-cuda:cuda12.0.0-runtime-ubuntu22.04-py3.10`

### CUDA 11.7.1 `cudnn8-runtime` image

- `base-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `minimal-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `r-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `scipy-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `datascience-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `tensorflow-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `pytorch-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `pyspark-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`
- `all-spark-notebook-cuda:cuda11.7.1-cudnn8-runtime-ubuntu22.04-py3.10`

For other combinations of Jupyter, CUDA, Ubuntu and Python, please [build your own](#build-your-own) using the included Makefile.


## Build your own

### Prerequisites

- [Docker](https://www.docker.com/)
- [Make](https://www.gnu.org/software/make/)
- Access to a Dockerhub account for pushing the images

### Getting Started

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

To build all the images from the most basic `docker-stacks-foundation-cuda` to the `all-pyspark-notebook-cuda`, run the following command:

```bash
make build-all
```

To build only a specific image and its prerequisite images, run the following command:

```bash
make build/<image-name>
```

Available image names are listed below
- `docker-stacks-foundation-cuda`
- `base-notebook-cuda`
- `minimal-notebook-cuda`
- `r-notebook-cuda`
- `scipy-notebook-cuda`
- `datascience-notebook-cuda`
- `tensorflow-notebook-cuda`
- `pytorch-notebook-cuda`
- `pyspark-notebook-cuda`
- `all-spark-notebook-cuda`

4. Run make to push the images to your Dockerhub account

```bash
make push-all
```

### Targets
The following `make` targets are available:

- `docker-stacks`: clones the Jupyter Docker Stacks repository from GitHub
- `build/docker-stacks-foundation-cuda`: builds the foundation image with CUDA support
- `build/%-cuda`: builds the specified image with CUDA support
- `build-all`: builds all images with CUDA support
- `push/%`: pushes the specified image to Dockerhub
- `push-all`: pushes all images to Dockerhub
