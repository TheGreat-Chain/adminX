#!/bin/bash

: '
    utils-adminX.sh

    Functions that change some system settings for the duration of the program execution.
'

# setLanguage()
# As the scripts is written in english, put the native command-line
# language in english too for consistency reasons
function setLanguage() {
    oldLANG=$LANG;
    oldLANGUAGE=$LANGUAGE

    export LANG=en_US.UTF-8;
    export LANGUAGE=en;
    source $HOME/.bashrc;
}

function resetLanguage() {
    export LANG=$oldLANG;
    export LANGUAGE=$oldLANGUAGE;
    source $HOME/.bashrc;
}

# forceRoot()
# If the command was not executed by root, warn the user and forces him to sudo
function forceRoot() {
    user=$(whoami);
    if [ "$user" != "root" ] 
    then    
        echo "Please use this script as root.";
        echo "Forcing sudo... ";
        sudo whoami 1> /dev/null;
    fi

    local status=$?
    if [ $status -eq 0 ]; then
        echo "Execution as root."
    else 
        echo "Exit with error code : $status";
        exit $status;
    fi
}
