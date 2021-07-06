#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
aws s3 cp s3://vabbucket123/index.html /var/www/html/
