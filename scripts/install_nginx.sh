#!/bin/bash

# Install nginx & nodejs
sudo dnf install nginx nodejs -y
sudo systemctl start nginx
sudo systemctl enable --now nginx
echo "Nginx has been installed and Node"

# Allow HTTP Traffic
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
echo "HTTP has been allowed"

# Installing MariaDB
sudo dnf install mariadb-server -y
echo "Enabling MariaDB"
sudo systemctl start mariadb
sudo systemctl enable --now mariadb


echo "Everything is up, run myqsl_secure_installation as super user to proceed"

