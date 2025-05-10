#!/bin/bash

# File paths
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOGS_DIR/deploy.log"

# Create logs directory if it doesn't exist
mkdir -p "$LOGS_DIR"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting deployment..."
log "[$(date '+%Y-%m-%d %H:%M:%S')] $1"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
log "Created temporary directory: $TEMP_DIR"

# Clone the repository
log "Cloning repository..."
git pull origin main
if [ $? -ne 0 ]; then
    log "Failed to pull latest changes from repository"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Copy website files to web server directory
log "Copying files to web directory..."
# Using a single sudo command to avoid the "cd command not found" error
sudo cp -r "$TEMP_DIR/repo/"* /var/www/html/

if [ $? -ne 0 ]; then
    log "Failed to copy files to web directory"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up temporary directory
log "Cleaning up..."
rm -rf "$TEMP_DIR"

# Restart web server
log "Restarting Nginx..."
sudo systemctl restart nginx

if [ $? -ne 0 ]; then
    log "Failed to restart Nginx"
    exit 1
fi

log "Deployment completed successfully!"
exit 0