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
    askUsernameForDeletion;
    askDeletionOfHomeDirectory;  # -r $deleteHomeDir
    askDeletionLoggedUser; # -f $forceDeletion

    if [ $deleteHomeDir -eq 0 ]; then
        if [ $forceDeletion -eq 0 ]; then # dont delete dir, dont force
            sudo userdel $userToDelete >& /dev/null;
        elif [ $forceDeletion -eq 1 ]; then # dont delete dir, force
            sudo userdel -f $userToDelete >& /dev/null; 
        fi
    elif [ $deleteHomeDir -eq 1 ]; then
        if [ $forceDeletion -eq 0 ]; then # delete dir, dont force
            sudo userdel -r $userToDelete >& /dev/null;
        elif [ $forceDeletion -eq 1 ]; then # delete dir, force
            sudo userdel -r -f $userToDelete  >& /dev/null;
        fi
    fi

    local errorCode=$?;
    deleteUser_errorCode=$errorCode; # for exiting with error code

    if [ $errorCode -eq 0 ]; then 
        echo "User deleted successfully. Bye $userToDelete !";

    elif [ $errorCode -eq 1 ]; then 
        echo "Can't update password file. Error code : $errorCode";

    elif [ $errorCode -eq 2 ]; then 
        echo "Invalid command syntax. Error code : $errorCode";

    elif [ $errorCode -eq 6 ]; then 
        echo "Specified user doesn't exist. Error code : $errorCode";

    elif [ $errorCode -eq 8 ]; then 
        echo "User currently logged in. Error code : $errorCode";

    elif [ $errorCode -eq 10 ]; then 
        echo "Can't update group file. Error code : $errorCode";

    elif [ $errorCode -eq 12 ]; then 
        echo "Can't remove home directory. Error code : $errorCode";
        
    fi

}

# updateUser()
# Updates an existing user
function updateUser() {
    askUserForUpdate; # userToUpdate

    #options : 
    updateUsername=0; #newUsername
    updateDirectory=0; # newUserHomeDirectory
    updateExpirationDate=0; # userNewExpirationDate
    updateShell=0; # newUserShell
    updateUID=0; # newUserId

    askUserModifications;

    echo "Modication of $userToUpdate ...";

    if [ $updateUsername -eq 1 ]; then
        sudo usermod -l $newUsername $userToUpdate;
        local status=$?;
        if [ $status -eq 0 ]; then
            userToUpdate=$newUsername;
            echo "Name updated...";
        else
            echo "Could not update user name. Error code : $?";
        fi
    fi

    if [ $updateDirectory -eq 1 ]; then
        sudo usermod -md $newUserHomeDirectory/$userToUpdate $userToUpdate
        local status=$?;
        if [ $status -eq 0 ]; then
            echo "Home directory updated...";
        else
            echo "Could not update user directory. Error code : $?";
        fi
    fi


    if [ $updateShell -eq 1 ]; then
        sudo usermod -s $newUserShell $userToUpdate
        local status=$?;
        if [ $status -eq 0 ]; then
            echo "Shell updated...";
        else
            echo "Could not update user shell. Error code : $?";
        fi
    fi


    if [ $updateUID -eq 1 ]; then
        sudo usermod -u $newUserId $userToUpdate
        local status=$?;
        if [ $status -eq 0 ]; then
            echo "UID updated...";
        else
            echo "Could not update user UID. Error code : $?";
        fi
    fi


    echo "User udpated :)"

}