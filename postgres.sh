#!/bin/bash
apt-get update -y
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main">/etc/apt/sources.list.d/pgdg.list
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
apt-get update -y
apt install postgresql postgresql-contrib -y
systemctl enable postgresql
systemctl start postgresql
systemctl status postgresql
sed -i 's/peer/trust/g' /etc/postgresql/*/main/pg_hba.conf
systemctl restart postgresql
systemctl status postgresql
runuser -l postgres -c 'createuser sonar'
psql -U postgres -c "ALTER USER sonar WITH ENCRYPTED password 'sonarqube';"
psql -U postgres -c "CREATE DATABASE sonarqube OWNER sonar;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
