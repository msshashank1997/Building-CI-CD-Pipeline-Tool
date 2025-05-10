#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CHECK_COMMITS_SCRIPT="$SCRIPT_DIR/check_commits.py"

# Make scripts executable
chmod +x "$CHECK_COMMITS_SCRIPT"
chmod +x "$SCRIPT_DIR/deploy.sh"

# Set up cron job to run every 5 minutes
(crontab -l 2>/dev/null; echo "*/5 * * * * cd $SCRIPT_DIR && $CHECK_COMMITS_SCRIPT") | crontab -

echo "Cron job set up to check for commits every 5 minutes"
echo "To view the cron job, run: crontab -l"