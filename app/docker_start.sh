#!/bin/bash

#set -x         #uncomment for debug

rm /var/run/apache2/*
rm /var/run/mysqld/*
rm /var/run/crond.pid

#in case the permissions were corrupted
chown -R www-data:www-data /app
#chown -R mysql:mysql /var/lib/mysql
#chown -R mysql:adm /var/log/mysql
#chown -R root:adm /var/log/apache2

# Initialize empty data volume and create MySQL user
# Reference 1: https://github.com/tutumcloud/mysql/blob/master/5.5/run.sh
# Reference 2: http://stackoverflow.com/questions/20456666/bash-checking-if-folder-has-contents
if test "$(ls -A "/var/lib/mysql")"; then
    echo "=> Using an existing volume of MySQL"
else
    echo "=> Installing MySQL ..."
    mysqld --initialize-insecure || exit 1
    service mysql start
    debian_pass=`grep -m 1 password /etc/mysql/debian.cnf  | cut -d' ' -f3`
    echo "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '$debian_pass'" | mysql -u root
    echo "=> Done!"
fi


service mysql start
service mysql status

service apache2 start
service apache2 status

mkdir /var/log/supervisor

#MYSQL need to be runned by supervisord
/usr/bin/supervisord
