#!/bin/bash

echo '======================================'
echo '|'
echo '| Server PHP'
echo '|'
echo '| ©wonowicki 2016'
echo '======================================'
echo ''

echo '======================================'
echo '| Pre Configuration'
echo '======================================'

# Get rid of stdin not tty errors etc - see https://github.com/mitchellh/vagrant/issues/1673
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# Set locale
locale-gen en_GB
locale-gen en_GB.utf8

# update apt-get
apt-get update

echo '======================================'
echo '| Installing Apache & PHP'
echo '======================================'

#install apache2, PHP and then MySQL
apt-get -y install apache2
apt-get -y install php5 # php5-mcrypt php5-xdebug

# Enable: ModRewrite, mcrypt
a2enmod rewrite
# php5enmod mcrypt

# Standard charset
sed -i 's/;default_charset = "UTF-8"/default_charset = "UTF-8"/g' /etc/php5/apache2/php.ini

# Make session directory writable
chmod -R 777 /var/lib/php5

# Link source public to public www
rm -R /var/www
ln -s /vagrant/www /var/

# Configure default vhost
cat /vagrant/vhost > /etc/apache2/sites-available/000-default.conf

# Restart apache
service apache2 restart

echo '======================================'
echo '| Installing Composer'
echo '======================================'

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer

cd /vagrant
