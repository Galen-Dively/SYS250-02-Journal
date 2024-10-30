#!/bin/bash

# Make sure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "Run with sudo!!!!"
   exit 1
fi

WIKI_DIR="/var/www/html/dokuwiki" # where the wiki will be stored

# Install necessary packages
echo "Installing packages..."
yum install -y httpd php php-json php-mbstring php-xml wget tar

# Start Apache
echo "Starting Web Server..."
systemctl start httpd
systemctl enable httpd

# Allow HTTP through the firewall
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Download DokuWiki
echo "Downloading DokuWiki..."
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz -O dokuwiki.tgz

# Create the wiki directory if it doesn't exist
mkdir -p "$WIKI_DIR"

# Extract the DokuWiki tarball directly into the wiki directory
tar -xvzf dokuwiki.tgz --strip-components=1 -C "$WIKI_DIR"

# Cleanup
rm dokuwiki.tgz # remove the downloaded tarball

# Set permissions
echo "Setting Permissions..."
chown -R apache:apache "$WIKI_DIR"
chmod -R 755 "$WIKI_DIR"

# Configure Apache
echo "Configuring Apache..."
cat <<EOL | tee /etc/httpd/conf.d/dokuwiki.conf
<VirtualHost *:80>
    DocumentRoot "$WIKI_DIR"
    DirectoryIndex index.php index.html

    <Directory "$WIKI_DIR">
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/dokuwiki_error.log
    CustomLog /var/log/httpd/dokuwiki_access.log combined
</VirtualHost>
EOL

# Restart Apache to apply changes
echo "Restarting Apache..."
systemctl restart httpd

# Finish
echo "Everything is installed"
