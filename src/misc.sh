#!/bin/bash

function install_tools()
{
    header 'Misc Tools'

    apt-get -y install nano htop multitail
}
