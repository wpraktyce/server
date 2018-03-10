#!/bin/bash

function install_mysql()
{
    header 'Installing MySQL'

    if [ "$1" != "" ]
    then
        THE_PASSWORD="$1"
    else
        THE_PASSWORD="password"
    fi

    if [[ "$2" != "" ]]
    then
        DATABASE_NAME="$2"
    else
        DATABASE_NAME="develop"
    fi

    echo "mysql-server-5.5 mysql-server/root_password password "$THE_PASSWORD | debconf-set-selections
    echo "mysql-server-5.5 mysql-server/root_password_again password "$THE_PASSWORD | debconf-set-selections

    apt-get -y install mysql-server

    # remove limits on network adapter
    sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf

    # replace key_buffer with key_buffer_size. key_buffer is deprecated (http://kb.parallels.com/en/120461)
    sed -i 's/key_buffer\s/key_buffer_size/' /etc/mysql/my.cnf

    # add standard config.
    cp /vagrant/conf/local.cnf /etc/mysql/conf.d/

    sed -i 's/innodb_buffer_pool_size/#innodb_buffer_pool_size/' /etc/mysql/conf.d/local.cnf

    # create database

    header 'Creating Database: '$DATABASE_NAME

    echo "CREATE DATABASE "$DATABASE_NAME | mysql -uroot -p$THE_PASSWORD

    unset THE_PASSWORD
    unset DATABASE_NAME

    service mysql restart
}

function mysql_add_user()
{

    header 'Adding MySQL user: '$1

    if [ "$3" != "" ]
    then
        THE_PASSWORD="$3"
    else
        THE_PASSWORD="password"
    fi

    if [[ "$4" != "" ]]
    then
        DATABASE_NAME="$4"
    else
        DATABASE_NAME="develop"
    fi

    echo "CREATE USER '"$1"'@'%' IDENTIFIED BY '"$2"';" | mysql -uroot -p$THE_PASSWORD
    echo "GRANT ALL PRIVILEGES ON "$DATABASE_NAME".* TO '"$1"'@'%' WITH GRANT OPTION;" | mysql -uroot -p$THE_PASSWORD

    # flush privilages
    echo "FLUSH PRIVILEGES;" | mysql -uroot -p$THE_PASSWORD

    unset THE_PASSWORD
    unset DATABASE_NAME
}
