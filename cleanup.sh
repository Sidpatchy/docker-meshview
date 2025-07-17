#!/bin/bash
set -e

DB_FILE=${DATABASE_FILE:-/app/packets.db}
RETENTION_DAYS=${RETENTION_DAYS:-14}

echo "Starting database cleanup - $(date)"
echo "Database: $DB_FILE"
echo "Retention: $RETENTION_DAYS days"

# Check if database exists and is accessible
if [ ! -f "$DB_FILE" ]; then
    echo "Database file not found: $DB_FILE"
    exit 1
fi

# Run cleanup queries
sqlite3 "$DB_FILE" <<EOF
DELETE FROM packet WHERE import_time < datetime('now', '-$RETENTION_DAYS day');
DELETE FROM packet_seen WHERE import_time < datetime('now', '-$RETENTION_DAYS day');
DELETE FROM traceroute WHERE import_time < datetime('now', '-$RETENTION_DAYS day');
DELETE FROM node WHERE last_update < datetime('now', '-$RETENTION_DAYS day') OR last_update IS NULL OR last_update = '';
VACUUM;
EOF

echo "Database cleanup completed - $(date)"
