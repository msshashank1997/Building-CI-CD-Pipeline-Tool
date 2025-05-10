# Testing Your CI/CD Pipeline

Follow these steps to test that your automated deployment works correctly:

## 1. Initial Setup Verification

1. Make sure your web server is running:
   ```bash
   sudo systemctl status nginx
   ```

2. Verify the cron job is set up:
   ```bash
   crontab -l
   ```

3. Check that the Python script can access GitHub:
   ```bash
   python3 scripts/check_commits.py
   ```

## 2. Make a Test Change

1. Modify the `index.html` file on your local machine:
   
   ```html
   <!-- Add this line to the body section -->
   <p>This is a test change to verify automatic deployment.</p>
   ```

2. Commit and push your changes:
   ```bash
   git add index.html
   git commit -m "Test automatic deployment"
   git push origin main
   ```

## 3. Verify Deployment

1. Wait for the next cron job to run (or run the script manually):
   ```bash
   python3 scripts/check_commits.py
   ```

2. Check the deployment logs:
   ```bash
   cat /var/log/deploy.log
   ```

3. Visit your website in a browser and verify the changes are visible

## 4. Troubleshooting

If the changes don't appear:

1. Check the logs:
   ```bash
   cat /var/log/commit_checker.log
   cat /var/log/deploy.log
   ```

2. Verify permissions:
   ```bash
   ls -la /var/www/html/
   ```

3. Try running the deployment script manually:
   ```bash
   bash scripts/deploy.sh
   ```
