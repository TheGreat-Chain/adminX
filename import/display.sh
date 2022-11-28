#!/bin/bash

: '
    display.sh

    This file contains the function that simply display text in the CLI
'

function printMenu() {
    echo "";
    echo "     =================================";
    echo "     |             ADMIN-X           |";
    echo "     |-------------------------------|";
    echo "     |       1. ADD a new user       |";
    echo "     |       2. UPDATE a user        |";
    echo "     |       3. DELETE an user       |";
    echo "     |       4. Quit :)              |";
    echo "     |-------------------------------|";
    echo "";

}

function printShells() {
    echo "";
    echo "Which SHELL do you want to use for this user ?";
    echo "1. bash";
    echo "2. sh";
    echo "3. dash";
    echo "4. zsh";
    echo "5. Ksh";
    echo "6. Tcsh";
    echo "7. Fish";
    echo "8. Other";
}