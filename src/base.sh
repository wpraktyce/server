#!/bin/bash

function base_setup()
{
    header 'Pre Configuration'

    # Get rid of stdin not tty errors etc - see https://github.com/mitchellh/vagrant/issues/1673
    sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

    # Set locale
    locale-gen en_GB
    locale-gen en_GB.utf8

    # update apt-get
    apt-get update
}

function header()
{
    echo '======================================'
    echo '| '$1
    echo '======================================'
}
