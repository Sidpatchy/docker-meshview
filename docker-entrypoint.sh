#!/bin/bash
set -e

# Default PUID and PGID
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Function to handle shutdown
cleanup() {
    echo "Shutting down Meshview..."
    kill -TERM $DB_PID 2>/dev/null || true
    kill -TERM $WEB_PID 2>/dev/null || true
    wait $DB_PID 2>/dev/null || true
    wait $WEB_PID 2>/dev/null || true
    exit 0
}

trap cleanup SIGTERM SIGINT

# Update user and group IDs if they differ from defaults
if [ "$PUID" != "1000" ] || [ "$PGID" != "1000" ]; then
    echo "Setting user meshview to UID: $PUID and GID: $PGID"

    # Update group
    groupmod -o -g "$PGID" meshview

    # Update user
    usermod -o -u "$PUID" meshview
fi

# Ensure proper ownership of app directory
chown -R meshview:meshview /app

CONFIG_FILE=${CONFIG_FILE:-/app/config.ini}
DATABASE_FILE=${DATABASE_FILE:-/app/packets.db}

# Function to run commands as meshview user
run_as_user() {
    gosu meshview "$@"
}

# Check and download config if needed (as meshview user)
if [ ! -s "$CONFIG_FILE" ]; then
    echo "Config file is empty, downloading default..."
    run_as_user curl -o "$CONFIG_FILE" https://raw.githubusercontent.com/pablorevilla-meshtastic/meshview/refs/heads/master/sample.config.ini
    echo "Config file downloaded successfully"
else
    echo "Config file already exists and has content"
fi

echo "Starting Meshview with config: $CONFIG_FILE"

# Start services as meshview user
echo "Starting database..."
run_as_user python startdb.py --config "$CONFIG_FILE" &
DB_PID=$!

sleep 5

echo "Starting web server..."
run_as_user python main.py --config "$CONFIG_FILE" &
WEB_PID=$!

wait $DB_PID $WEB_PID
