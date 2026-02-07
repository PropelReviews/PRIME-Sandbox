# ---- Base image: NVIDIA NGC TensorFlow (CUDA 12.8, driver 570+) ----
# This image supports Blackwell GPUs (RTX 5070, sm_120) out of the box.
# Falls back to CPU-only if no GPU is available at runtime.
FROM nvcr.io/nvidia/tensorflow:25.02-tf2-py3

LABEL maintainer="Sam Rossilli - Propel"
LABEL description="TensorFlow development environment for transformer model experiments"

# Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    vim \
    build-essential \
    openssh-client \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy and install Python dependencies
# (NGC image already has TF, numpy, etc. — pip will skip what's satisfied)
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Register this Python as the default Jupyter kernel so notebooks
# use the environment where TF + all dependencies are installed.
RUN python3 -m ipykernel install --name python3 --display-name "Python 3 (TF)" \
    && jupyter kernelspec list

# Copy project files
COPY . .

# Expose ports for Jupyter and TensorBoard
EXPOSE 8888 6006

# Default command
CMD ["bash"]
