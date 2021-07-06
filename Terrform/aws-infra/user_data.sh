#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
aws s3 cp s3://vab1bucket/index.html /var/www/html/index.html
