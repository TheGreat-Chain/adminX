#!/bin/bash

: ' 
    userAdministration.sh

    This file contains all that wrap useradd userdel and usermod
'

# createUser()
# Let's the user type all the necessary informations to create an user
# Then creates an user with useradd
function createUser() {
    askUsername; # $username
    askUserHomeDirectory; # $userHomeDirectory
    askExpirationDate; # $userExpirationDate
    #askPassword; # $userPassword
    askShell; # $userShell
    askId; # $userId

    sudo useradd -m -b $userHomeDirectory -s $userShell -u $userId -e $userExpirationDate $username
    echo "Type the user password : "
    sudo passwd $username #the -p option of useradd is not recommanded in the manual

    echo "User $username created successfully :)"
}

# deleteUser()
# Let's the user delete an user
function deleteUser() {
    askUsernameForDeletion; # $userToDelete
    askDeletionOfHomeDirectory; # -r $deleteHomeDir
    askDeletionLoggedUser; # -f $forceDeletion

    if [ $deleteHomeDir -eq 0 ]; then
        if [ $forceDeletion -eq 0 ]; then # dont delete dir, dont force
            sudo userdel $userToDelete;
        elif [ $forceDeletion -eq 1 ]; then # dont delete dir, force
            sudo userdel -f $userToDelete; 
        fi
    elif [ $deleteHomeDir -eq 0 ]; then
        if [ $forceDeletion -eq 0 ]; then # delete dir, dont force
            sudo userdel -r $userToDelete ;
        elif [ $forceDeletion -eq 1 ]; then # delete dir, force
            sudo userdel -r -f $userToDelete;
        fi
    fi

}