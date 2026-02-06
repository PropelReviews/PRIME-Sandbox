# PRIME

Transformer model experiments built with TensorFlow / Keras.

## Project Structure

```
PRIME/
├── .devcontainer/        # VS Code devcontainer config
│   └── devcontainer.json
├── configs/              # Hydra experiment configs (YAML)
│   └── default.yaml
├── data/                 # Datasets (not committed — use DVC or Git LFS)
├── notebooks/            # Jupyter notebooks for exploration
├── src/                  # Source code
│   ├── data/             # Data loading & preprocessing
│   ├── models/           # Model definitions
│   └── utils/            # Shared utilities
├── tests/                # Unit & integration tests
├── Dockerfile            # TensorFlow GPU development image
├── requirements.txt      # Python dependencies
└── README.md
```

## Quick Start

### Option A — Dev Container (recommended)

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and the **Dev Containers** extension in Cursor / VS Code.
2. Open this repo and choose **"Reopen in Container"** from the command palette (`Ctrl+Shift+P`).
3. The container will build automatically. Jupyter Lab and TensorBoard ports are forwarded for you.

### Option B — Docker manually

```bash
# Build the image
docker build -t prime .

# Run with GPU support
docker run --gpus all -it --rm \
  -v $(pwd):/workspace \
  -p 8888:8888 -p 6006:6006 \
  prime

# Run CPU-only
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 8888:8888 -p 6006:6006 \
  prime
```

### Option C — Local virtual environment

```bash
python -m venv .venv
source .venv/bin/activate   # Linux/Mac
# .venv\Scripts\activate    # Windows
pip install -r requirements.txt
```

## Running Experiments

```bash
# Start Jupyter Lab
jupyter lab --ip 0.0.0.0 --no-browser

# Launch TensorBoard
tensorboard --logdir logs --bind_all
```

Experiment configuration lives in `configs/`. Override values with Hydra:

```bash
python train.py model.num_layers=12 training.learning_rate=3e-5
```

## GPU Notes

- The Docker image is based on `tensorflow/tensorflow:2.16.1-gpu-jupyter` and includes CUDA/cuDNN.
- If you don't have an NVIDIA GPU the container still works — TensorFlow falls back to CPU automatically.
- The devcontainer passes `--gpus all` so your host GPU is available inside the container.
