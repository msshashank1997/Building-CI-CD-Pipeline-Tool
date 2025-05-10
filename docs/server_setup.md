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
sudo apt install -y git  # Ubuntu
# Install Python and dependencies
sudo apt install -y python3 python3-pip  # Ubuntu
# Install required Python packages
pip3 install requests
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
