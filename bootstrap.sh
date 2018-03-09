#!/bin/bash

echo '======================================'
echo '|'
echo '| Server PHP'
echo '|'
echo '| ©wonowicki 2016-2018'
echo '======================================'
echo ''

cd /vagrant

for THIS_FILE in src/*
do
    source $THIS_FILE
done

base_setup

## Configuration:

install_apache
install_composer
install_mysql
mysql_add_user user pass
install_tools
