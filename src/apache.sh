#!/bin/bash

function install_apache()
{
    header 'Installing Apache & PHP'

    #install apache2, PHP and then MySQL
    apt-get -y install apache2
    apt-get -y install php5 php5-mysql # php5-mcrypt php5-xdebug

    # Enable: ModRewrite, mcrypt
    a2enmod rewrite
    # php5enmod mcrypt

    # Conf PHP
    PHP_LOG_FILE="/var/log/php.log"
    touch "$PHP_LOG_FILE"
    chmod 777 "$PHP_LOG_FILE"
    sed -i -e s@";error_log = php_errors.log"@"error_log = $PHP_LOG_FILE"@g /etc/php5/apache2/php.ini
    sed -i s/"error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT"/"error_reporting = E_ALL"/g /etc/php5/apache2/php.ini
    sed -i s/"session.cookie_httponly ="/"session.cookie_httponly = On"/g /etc/php5/apache2/php.ini
    sed -i s/";session.cookie_secure ="/"session.cookie_secure = On"/g /etc/php5/apache2/php.ini
    sed -i s/"display_errors = Off"/"display_errors = On"/g /etc/php5/apache2/php.ini
    unset PHP_LOG_FILE

    # Standard charset
    sed -i 's/;default_charset = "UTF-8"/default_charset = "UTF-8"/g' /etc/php5/apache2/php.ini

    # Make session directory writable
    chmod -R 777 /var/lib/php5

    # Link source public to public www
    rm -R /var/www
    ln -s /vagrant/www /var/

    # Configure default vhost
    cat /vagrant/conf/vhost/default > /etc/apache2/sites-available/000-default.conf

    # Restart apache
    service apache2 restart
}
