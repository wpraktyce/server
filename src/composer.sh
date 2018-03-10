#!/bin/bash

function install_composer()
{
    header 'Installing Composer'

    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/bin/composer
}
