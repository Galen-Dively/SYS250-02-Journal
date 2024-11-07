#!/bin/bash

# Install nginx
sudo dnf install nginx -y
sudo systemctl enable --now nginx
echo "Nginx has been installed"

# Allow HTTP Traffic
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
echo "HTTP has been allowed"
