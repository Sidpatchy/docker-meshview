# docker-meshview

Docker container for [Meshview](https://github.com/pablorevilla-meshtastic/meshview) - a real-time monitoring and diagnostic tool for Meshtastic mesh networks.

## Quick Start
Ensure you have Docker installed using the officially supported method.

https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

```bash
# Clone the repo and enter its directory
$ git clone https://github.com/Sidpatchy/docker-meshview
$ cd docker-meshview

# Build the container
$ docker compose build --no-cache

# Initialize the config and database file
$ touch packets.db
$ chmod 666 packets.db

# Check your UID and GID
$ id
uid=1000(testuser) gid=1000(testuser) # You should get something like this

# Edit the docker-compose file to use your UID and GID
$ nano docker-compose.yml

# Change the PUID to your UID and the PGID to your GID
- PUID=1000
- PGID=1000

# Download the config from upstream and modify to your liking
$ curl -o config.ini https://raw.githubusercontent.com/pablorevilla-meshtastic/meshview/refs/heads/master/sample.config.ini
$ nano config.ini

# Start the contaner
$ docker compose up -d
```
