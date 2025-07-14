#!/bin/bash
set -e

# Function to handle shutdown
cleanup() {
    echo "Shutting down Meshview..."
    kill -TERM $DB_PID 2>/dev/null || true
    kill -TERM $WEB_PID 2>/dev/null || true
    wait $DB_PID 2>/dev/null || true
    wait $WEB_PID 2>/dev/null || true
    exit 0
}

# Set trap for cleanup
trap cleanup SIGTERM SIGINT

# Default config file
CONFIG_FILE=${CONFIG_FILE:-/app/config.ini}

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found at $CONFIG_FILE"
    echo "Creating default config from sample..."
    cp /app/sample.config.ini "$CONFIG_FILE"
fi

echo "Starting Meshview with config: $CONFIG_FILE"

# Start database in background
echo "Starting database..."
python startdb.py --config "$CONFIG_FILE" &
DB_PID=$!

# Wait a bit for database to initialize
sleep 5

# Start web server in background
echo "Starting web server..."
python main.py --config "$CONFIG_FILE" &
WEB_PID=$!

# Wait for processes
wait $DB_PID $WEB_PID
