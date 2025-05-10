#!/bin/bash

# Get the directory where scripts are located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK_SCRIPT="$SCRIPT_DIR/check_commits.py"

# Make scripts executable
chmod +x "$CHECK_SCRIPT"
chmod +x "$SCRIPT_DIR/deploy.sh"

# Create a temporary file
TEMP_CRON=$(mktemp)

# Backup existing crontab
crontab -l > "$TEMP_CRON" 2>/dev/null

# Check if the job already exists
if grep -q "$CHECK_SCRIPT" "$TEMP_CRON"; then
    echo "Cron job already exists. No changes made."
else
    # Add the job to run every 5 minutes
    echo "# Check for new commits every 5 minutes" >> "$TEMP_CRON"
    echo "*/5 * * * * $CHECK_SCRIPT >> /var/log/commit_checker.log 2>&1" >> "$TEMP_CRON"
    
    # Install the new crontab
    crontab "$TEMP_CRON"
    echo "Cron job installed. The script will run every 5 minutes."
fi

# Clean up
rm "$TEMP_CRON"

echo "You can verify the cron job with: crontab -l"
