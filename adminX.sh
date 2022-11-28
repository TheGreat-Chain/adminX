#!/bin/bash

source ./import/utils.sh;
source ./import/display.sh;
source ./import/userAdministration.sh;
source ./import/askUser.sh;

function main() {
    setLanguage;
    forceRoot;

    printMenu;
    handleUserInput;

    resetLanguage;
    exit 0;
}

main;