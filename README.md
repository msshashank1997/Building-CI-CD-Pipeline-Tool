# CI/CD Pipeline Demo

This project demonstrates a simple CI/CD pipeline that automatically deploys an HTML website when changes are pushed to GitHub.

## Setup

1. Clone this repository
2. Set up your web server with Nginx
3. Configure the deployment scripts
4. Set up a cron job for automatic deployments

## Project Structure

- `index.html` - Main webpage
- `styles.css` - CSS styling
- `scripts/` - Contains deployment automation scripts

# Server Setup Instructions

## Setting up AWS EC2 Instance

1. Launch an EC2 instance using Ubuntu
2. Make sure to open ports 22 (SSH) and 80 (HTTP) in the security group
3. Connect to your instance using SSH

## Installing Nginx

### For Ubuntu:
```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

## Install Required Software

```bash
# Install Git
sudo apt install -y git 
sudo apt install -y python3 python3-pip
sudo apt install -y git python3 python3-full python3-venv
```

```
# Clone repository
git clone https://github.com/msshashank1997/Building-CI-CD-Pipeline-Tool.git
cd Building-CI-CD-Pipeline-Tool/scripts

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt
sudo chmod 777 check_commits.py deploy.sh setup_cron.sh
```

## Configure File Permissions

```bash
# Give your user permission to write to the web directory
sudo usermod -a -G www-data $USER
sudo chown -R $USER:www-data /var/www/html
sudo chmod -R 775 /var/www/html
```

## Test Nginx Installation

Open your browser and navigate to your server's IP address. You should see the default Nginx welcome page.

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
   python3 check_commits.py
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