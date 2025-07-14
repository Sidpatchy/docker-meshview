FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    graphviz \
    sqlite3 \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone meshview with all submodules directly
RUN git clone --recurse-submodules https://github.com/pablorevilla-meshtastic/meshview.git . && \
    rm -rf .git

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p /app/data

# Copy startup script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Create non-root user
RUN groupadd -r meshview && useradd -r -g meshview meshview
RUN chown -R meshview:meshview /app

# Switch to non-root user
USER meshview

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Use custom entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
