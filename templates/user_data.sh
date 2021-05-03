#!/bin/bash:
sudo su
yum install httpd -y
service httpd start
cd /var/www/html
echo "hello this is vikas here" > /var/www/html/index.html

