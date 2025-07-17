FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    graphviz \
    sqlite3 \
    git \
    curl \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone meshview with all submodules directly
RUN git clone --recurse-submodules https://github.com/pablorevilla-meshtastic/meshview.git . && \
    rm -rf .git

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy startup script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Pre-create files that will be bind-mounted
RUN touch /app/config.ini /app/packets.db

# Create default user (will be modified at runtime)
RUN groupadd -r -g 1000 meshview && useradd -r -u 1000 -g meshview meshview

# Don't switch to non-root user yet - this will happen in the entrypoint
# USER meshview

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Use custom entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
