# docker-meshview

Docker container for [Meshview](https://github.com/pablorevilla-meshtastic/meshview) - a real-time monitoring and diagnostic tool for Meshtastic mesh networks.

## Quick Start
Ensure you have Docker installed using the officially supported method.

https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

```bash
# Clone the repo and enter its directory
git clone https://github.com/Sidpatchy/docker-meshview
cd docker-meshview

# Build the container
docker compose build

# Create the ./data/ directory
mkdir data/

# Download the config file example from upstream
curl -o config.ini https://raw.githubusercontent.com/pablorevilla-meshtastic/meshview/refs/heads/master/sample.config.ini

# Modify the config file to your liking
nano config.ini

# Start the container
docker compose up -d
```

