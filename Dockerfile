# ---- Base image: TensorFlow with GPU support ----
# Falls back to CPU-only if no GPU is available at runtime
FROM tensorflow/tensorflow:2.16.1-gpu-jupyter

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
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --ignore-installed blinker && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose ports for Jupyter and TensorBoard
EXPOSE 8888 6006

# Default command
CMD ["bash"]
