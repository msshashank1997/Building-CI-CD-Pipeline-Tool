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

# Create a temporary directory
TEMP_DIR=$(mktemp -d -t website-deployment.XXXXXX)
log "Created temporary directory: $TEMP_DIR"

# Clone the repository
log "Cloning repository..."
git clone https://github.com/msshashank1997/Building-CI-CD-Pipeline-Tool.git "$TEMP_DIR/repo"
if [ $? -ne 0 ]; then
    log "Failed to clone repository"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Copy website files to web server directory
log "Copying files to web directory..."
cp -r "$TEMP_DIR/repo/"* /var/www/html/ 2>/dev/null || {
    # If the above fails, try with sudo
    log "Permission denied, trying with sudo..."
    sudo cp -r "$TEMP_DIR/repo/"* /var/www/html/
}

if [ $? -ne 0 ]; then
    log "Failed to copy files to web directory"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up temporary directory
log "Cleaning up..."
rm -rf "$TEMP_DIR"

# Restart web server (if needed)
log "Restarting Nginx..."
sudo systemctl restart nginx || {
    log "Failed to restart Nginx"
    exit 1
}

log "Deployment completed successfully!"
exit 0