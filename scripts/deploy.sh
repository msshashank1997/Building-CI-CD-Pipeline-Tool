#!/bin/bash

# Configuration
REPO_URL="https://github.com/your-github-username/your-repo-name.git"
BRANCH="main"
TEMP_DIR="/tmp/website-deployment"
WEB_ROOT="/var/www/html"  # Nginx default web root
LOG_FILE="/var/log/deploy.log"

# Ensure log file exists
touch $LOG_FILE

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

log "Starting deployment..."

# Create temp directory if it doesn't exist
if [ ! -d "$TEMP_DIR" ]; then
    mkdir -p "$TEMP_DIR"
    log "Created temporary directory: $TEMP_DIR"
fi

# Navigate to temp directory
cd "$TEMP_DIR" || { log "Failed to navigate to $TEMP_DIR"; exit 1; }

# Clone or pull latest code
if [ -d ".git" ]; then
    log "Repository exists. Pulling latest changes..."
    git pull origin $BRANCH || { log "Git pull failed"; exit 1; }
else
    log "Cloning the repository..."
    git clone --branch $BRANCH $REPO_URL . || { log "Git clone failed"; exit 1; }
fi

# Copy files to web root (excluding .git and scripts directory)
log "Copying files to web root..."
rsync -av --exclude='.git' --exclude='scripts' ./ $WEB_ROOT/ || { log "Failed to copy files"; exit 1; }

# Set correct permissions
log "Setting permissions..."
chown -R www-data:www-data $WEB_ROOT || { log "Failed to set permissions"; exit 1; }

# Test Nginx configuration and reload
log "Testing Nginx configuration..."
nginx -t
if [ $? -eq 0 ]; then
    log "Reloading Nginx..."
    systemctl reload nginx || { log "Failed to reload Nginx"; exit 1; }
else
    log "Nginx configuration test failed!"
    exit 1
fi

log "Deployment completed successfully!"
