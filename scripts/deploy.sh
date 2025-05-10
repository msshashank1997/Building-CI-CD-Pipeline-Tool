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
TEMP_DIR=$(mktemp -d)
log "Created temporary directory: $TEMP_DIR"

# Clone the repository
log "Cloning repository..."
git clone https://github.com/msshashank1997/Building-CI-CD-Pipeline-Tool.git "$TEMP_DIR/repo"
if [ $? -ne 0 ]; then
    log "Failed to clone repository"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Copy website files to web directory
log "Copying files to web directory..."
# Add echo for debugging
echo "Source directory contents:"
ls -la "$TEMP_DIR/repo/"

# Try using sudo with password configured for non-interactive use
sudo cp -r "$TEMP_DIR/repo/"* /var/www/html/ || {
    log "Regular sudo failed, trying alternative method..."
    # Alternative approach - copy to temp location and use sudo to move
    cp -r "$TEMP_DIR/repo/"* "$TEMP_DIR/webfiles/"
    sudo mv "$TEMP_DIR/webfiles/"* /var/www/html/
}

# Clean up temporary directory
log "Cleaning up..."
sudo rm -rf "$TEMP_DIR"

# Restart web server
log "Restarting Nginx..."
sudo systemctl restart nginx

if [ $? -ne 0 ]; then
    log "Failed to restart Nginx"
    exit 1
fi

log "Deployment completed successfully!"
exit 0