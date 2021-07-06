#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
echo "Hii this vikas here" > /var/www/html/index.html
