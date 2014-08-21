#!/usr/bin/env bash
# WordPress Vagrant config
# Author:  Dan Bough (daniel <dot> bough <at> gmail <dot> com / www.danielbough.com)
# License:  GPLv3
# Copyright 2014
# 
# Packages installed:  mysql 5.5, php5 with mysql drivers, apache2, git

# Unlock the root and give it a password? (YES/NO)
ROOT=YES

# WordPress repo to download
REPO=3.9-branch

# Database Info
DB_NAME=WordPress
DB_PASSWORD=password

if [ ! -f /var/log/firsttime ];
then
	sudo touch /var/log/firsttime

    # Set credentials for MySQL
	sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $DB_PASSWORD"
	sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $DB_PASSWORD"

    # Install packages
	sudo apt-get update
	sudo apt-get -y install mysql-server-5.5 php5-mysql apache2 git libapache2-mod-php5

    # Create WordPress database
    sudo mysql -uroot -p$DB_PASSWORD -e "CREATE DATABASE $DB_NAME"

    # Add timezones to database
    mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -uroot -p$DB_PASSWORD mysql

    # Download WordPress
    sudo git clone https://github.com/WordPress/WordPress.git -b $REPO /home/vagrant/shared/wordpress

    # Remove create a simlink to wordpress
    sudo rm -r -f /var/www/*
    sudo ln -s /home/vagrant/shared/wordpress/* /var/www/
    
    # Create wp-config.php
    sudo mv /home/vagrant/shared/wordpress/wp-config-sample.php /home/vagrant/shared/wordpress/wp-config.php
    sudo sed -i "s/database_name_here/$DB_NAME/" /home/vagrant/shared/wordpress/wp-config.php
    sudo sed -i "s/username_here/root/" /home/vagrant/shared/wordpress/wp-config.php
    sudo sed -i "s/password_here/$DB_PASSWORD/" /home/vagrant/shared/wordpress/wp-config.php    

    # Allow URL rewrites
    sudo a2enmod rewrite
    sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default

    # php5-mysql comes w/mysql drivers, but we still have to update php.ini to use them.
    sudo sed -i 's/;pdo_odbc.db2_instance_name/;pdo_odbc.db2_instance_name\nextension=pdo_mysql.so/' /etc/php5/apache2/php.ini
	
    sudo service apache2 restart
fi

# Unlock root and set password	
if [ $ROOT = 'YES' ]
then
	sudo usermod -U root
	echo -e "password\npassword" | sudo passwd root
fi