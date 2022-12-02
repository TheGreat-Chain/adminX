#!/bin/bash

: ' 
    askUser.sh

    This file contains all the functions that involve user input.
'

# handleUserInput()
# Calls the right functions depending on the user choice
function handleUserInput() {
    while true
    do
        read option;
        case $option in 
            "1")
                createUser;
                resetLanguage;
                exit 0;
                ;;

            "2")
                updateUser;
                resetLanguage;
                exit 0;
                ;;

            "3")
                deleteUser;
                resetLanguage;
                exit $deleteUser_errorCode;
                ;;
            
            "4")
                echo "Bye !"
                resetLanguage;  
                exit 0;
                ;;

            *) 
                echo "Please choose one of the above options (1-4)"
        esac
    done
}


# askUsername()
# Let's the user write a non-empty user name and create a variable for that
function askUsername() {
    echo "Enter the user's name : "
    success=0
    while [ $success -eq 0 ]
    do
        echo -n "USER NAME : "
        read username;
        if [ -z "$username" ] # empty ?
        then 
            echo "The username is empty. Try again.";

        elif [[ "$username" = *" "* ]]
        then
            echo "Do not put spaces in the username. Try again.";

        else
            usernameTaken=$(grep $username /etc/passwd);
            if [ -z "$usernameTaken" ] #emtpy ?
            then 
                success=1;
                echo "Chosen username : $username";
            else
                echo "The username $username is already taken";
            fi
        fi
    done
    echo ""
}

function askNewUsername() {
    echo "Enter the new user's name : "
    success=0
    while [ $success -eq 0 ]
    do
        echo -n "USER NAME : "
        read newUsername;
        if [ -z "$newUsername" ] # empty ?
        then 
            echo "The username is empty. Try again.";

        elif [[ "$newUsername" = *" "* ]]
        then
            echo "Do not put spaces in the username. Try again.";

        else
            usernameTaken=$(grep $newUsername /etc/passwd);
            if [ -z "$usernameTaken" ] #emtpy ?
            then 
                success=1;
                echo "Chosen username : $newUsername";
            else
                echo "The username $newUsername is already taken";
            fi
        fi
    done
    echo ""
}

function askUserForUpdate() {
    echo "Type the name of the user you want to update : "
    local success=0;

    while [ $success -eq 0 ]
    do
        echo -n "USER NAME : "
        read userToUpdate;
        if [ -z "$userToUpdate" ] # empty ?
        then 
            echo "The username is empty. Try again.";

        elif [[ "$userToUpdate" = *" "* ]]
        then
            echo "User names do not contain spaces. Try again.";

        else
            getent passwd $userToUpdate &> /dev/null;
            local status=$?;
            if [ $status -eq 0 ]; then
                success=1;
                echo "Chosen user to update : $userToUpdate";
            else 
                echo "The user $userToUpdate does not exist";
            fi
        fi
    done
    echo ""
}

# askUsernameForDeletion()
# Let's the user write a non-empty user name and create a variable for that
function askUsernameForDeletion() {
    echo "Type the name of the user you want to delete : "
    local success=0
    while [ $success -eq 0 ]
    do
        echo -n "USER NAME : "
        read userToDelete;
        if [ -z "$userToDelete" ] # empty ?
        then 
            echo "The username is empty. Try again.";

        elif [[ "$userToDelete" = *" "* ]]
        then
            echo "User names do not contain spaces. Try again.";

        else
            getent passwd $userToDelete &> /dev/null;
            local status=$?;
            if [ $status -eq 0 ]; then
                success=1;
                echo "Chosen user to delete : $userToDelete";
            else 
                echo "The user $userToDelete does not exist";
            fi
        fi
    done
    echo ""
}

# askUserHomeDirectory()
function askUserHomeDirectory() {
    echo "Enter the user's home directory path : "
    local success=0
    while [ $success -eq 0 ]
    do
        echo -n "HOME DIRECTORY : "
        read userHomeDirectory;
        if [ -z "$userHomeDirectory" ] # empty ?
        then
            echo "The user's home directory path is empty. Try again."

        elif [[ -d "$userHomeDirectory/$username" ]]
        then   
            echo "The path : $userHomeDirectory/$username already exists."

        else
            success=1
            echo "Chosen path : $userHomeDirectory"
        fi
    done
    echo ""
}

# askUserHomeDirectoryForUpdate()
function askNewUserHomeDirectory() {
    echo "Enter the new user's home directory path : "
    local success=0
    while [ $success -eq 0 ]
    do
        echo -n "HOME DIRECTORY : "
        read newUserHomeDirectory;
        if [ -z "$newUserHomeDirectory" ] # empty ?
        then
            echo "The user's home directory path is empty. Try again."

        elif [[ -d "$newUserHomeDirectory/$newUsername" ]]
        then   
            echo "The path : $newUserHomeDirectory/$newUsername already exists."

        else
            success=1
            echo "Chosen path : $newUserHomeDirectory"
        fi
    done
    echo ""
}

# askExpirationDate()
function askExpirationDate() {
    echo "Enter the user's expiration date : ";
    
    currentYear=$(date +"%Y");
    currentMonth=$(date +"%m");
    currentDay=$(date +"%d");
    success=0;

    # YEAR
    while [ $success -eq 0 ]
    do
        echo -n "YEAR : ";
        read year;
        if [ -z "$year" ] # empty ?
        then
            echo "The year is empty. Try again.";

        elif ! [[ "$year" =~ ^[0-9]+$ ]] # is a number ?
        then 
            exec >&2; echo "You did not enter a number. Try again";

        elif [ $year -lt $currentYear ] # older date ?
        then 
            echo "Please, do not type an date older than the current date. Try again."

        else
            success=1
        fi
    done

    # MONTH 
    success=0;
    while [ $success -eq 0 ]
    do
        echo -n "MONTH : ";
        read month;
        if [ -z "$month" ] # empty ?
        then
            echo "The month is empty. Try again.";

        elif ! [[ "$month" =~ ^[0-9]+$ ]] # is a number ?
        then 
            exec >&2; echo "You did not enter a number. Try again";

        elif [ $month -gt 12 ] || [ $month -lt 1 ] # not between 1 and 12 ?
        then    
            echo "A month is between 1 and 12 (january - december). Try again"

        elif [ $year -eq $currentYear ] && [ $month -lt $currentMonth ] # older date ?
        then 
            echo "Please, do not type an date older than the current date. Try again.";

        else
            success=1
        fi
    done

    # DAY
    success=0;
    while [ $success -eq 0 ]
    do
        echo -n "DAY : ";
        read day;
        if [ -z "$day" ] # empty ?
        then
            echo "The day is empty. Try again.";

        elif ! [[ "$day" =~ ^[0-9]+$ ]] # is a number ?
        then 
            exec >&2; echo "You did not enter a number. Try again";
        
        elif [ $day -gt 31 ] || [ $day -lt 1 ] # not between 1 and 12 ?
        then    
            echo "A day is between 1 and 31. Try again"

        elif [ $month -eq 2 ] && [ $day -gt 29 ] # february
        then 
            echo "There are only 29 days in february."

        elif [ $year -eq $currentYear ] && [ $month -eq $currentMonth ] && [ $day -le $currentDay ] # older date ?
        then
            echo "Please, do not type an date older than the current date. Try again.";

        else
            userExpirationDate="$year-$month-$day";
            echo "The user's expiration date is : $userExpirationDate";
            success=1;
        fi
    done

    echo ""
}

function askNewExpirationDate() {
    echo "Enter the new user's expiration date : ";
    
    currentYear=$(date +"%Y");
    currentMonth=$(date +"%m");
    currentDay=$(date +"%d");
    success=0;

    # YEAR
    while [ $success -eq 0 ]
    do
        echo -n "YEAR : ";
        read year;
        if [ -z "$year" ] # empty ?
        then
            echo "The year is empty. Try again.";

        elif ! [[ "$year" =~ ^[0-9]+$ ]] # is a number ?
        then 
            exec >&2; echo "You did not enter a number. Try again";

        elif [ $year -lt $currentYear ] # older date ?
        then 
            echo "Please, do not type an date older than the current date. Try again."

        else
            success=1
        fi
    done

    # MONTH 
    success=0;
    while [ $success -eq 0 ]
    do
        echo -n "MONTH : ";
        read month;
        if [ -z "$month" ] # empty ?
        then
            echo "The month is empty. Try again.";

        elif ! [[ "$month" =~ ^[0-9]+$ ]] # is a number ?
        then 
            exec >&2; echo "You did not enter a number. Try again";

        elif [ $month -gt 12 ] || [ $month -lt 1 ] # not between 1 and 12 ?
        then    
            echo "A month is between 1 and 12 (january - december). Try again"

        elif [ $year -eq $currentYear ] && [ $month -lt $currentMonth ] # older date ?
        then 
            echo "Please, do not type an date older than the current date. Try again.";

        else
            success=1
        fi
    done

    # DAY
    success=0;
    while [ $success -eq 0 ]
    do
        echo -n "DAY : ";
        read day;
        if [ -z "$day" ] # empty ?
        then
            echo "The day is empty. Try again.";

        elif ! [[ "$day" =~ ^[0-9]+$ ]] # is a number ?
        then 
            exec >&2; echo "You did not enter a number. Try again";
        
        elif [ $day -gt 31 ] || [ $day -lt 1 ] # not between 1 and 12 ?
        then    
            echo "A day is between 1 and 31. Try again"

        elif [ $month -eq 2 ] && [ $day -gt 29 ] # february
        then 
            echo "There are only 29 days in february."

        elif [ $year -eq $currentYear ] && [ $month -eq $currentMonth ] && [ $day -le $currentDay ] # older date ?
        then
            echo "Please, do not type an date older than the current date. Try again.";

        else
            userNewExpirationDate="$year-$month-$day";
            echo "New user's expiration date : $userNewExpirationDate";
            success=1;
        fi
    done

    echo ""
}


# askPassword()
function askPassword() {
    echo "Enter the user's password  : "
    success=0
    while [ $success -eq 0 ]
    do
        echo -n "PASSWORD : "
        stty -echo # hide input
        read -r userPassword;
        stty echo

        if [ -z "$userPassword" ] # empty ?
        then
            echo "The user's password is empty. Try again."

        else
            success=1
        fi
    done
    
    echo ""
}

function askNewShell() {
    printShells;
    local finished=0;
    while [ $finished -eq 0 ]
    do
        read shellOption;
        case $shellOption in 
            "1") # bash
                newUserShell=$(command -v bash)
                if [ -z "$newUserShell" ] #empty ?
                then 
                    echo "bash is not installed in your system. Installation..."
                    sudo apt-get install bash -y 1> /dev/null
                    newUserShell=$(command -v bash)
                fi
                finished=1
                ;;

            "2") # sh
                newUserShell=$(command -v sh)
                if [ -z "$newUserShell" ] #empty ?
                then 
                    echo "sh is not installed in your system. Installation..."
                    sudo apt-get install sh -y 1> /dev/null
                    newUserShell=$(command -v sh)
                fi
                finished=1
                ;;

            "3") # dash
                newUserShell=$(command -v dash)
                if [ -z "$newUserShell" ] #empty ?
                then 
                    echo "dash is not installed in your system. Installation..."
                    sudo apt-get install dash -y 1> /dev/null
                    newUserShell=$(command -v dash)
                fi
                finished=1
                ;;
            
            "4") # zsh
                newUserShell=$(command -v zsh)
                if [ -z "$newUserShell" ] #empty ?
                then 
                    echo "zsh is not installed in your system. Installation..."
                    sudo apt-get install zsh -y 1> /dev/null
                    newUserShell=$(command -v zsh)
                fi
                finished=1
                ;;

            "5") #ksh 
                newUserShell=$(command -v ksh)
                if [ -z "$newUserShell" ] #empty ?
                then 
                    echo "ksh is not installed in your system. Installation..."
                    sudo apt-get install ksh -y 1> /dev/null
                    newUserShell=$(command -v ksh)
                fi
                finished=1
                ;;

           "6") #tcsh
                newUserShell=$(command -v tcsh)
                if [ -z "$newUserShell" ] #empty ?
                then 
                    echo "tcsh is not installed in your system. Installation..."
                    sudo apt-get install tcsh -y 1> /dev/null
                    newUserShell=$(command -v tcsh)
                fi
                finished=1
                ;;

           "7") #fish
                newUserShell=$(command -v fish)
                if [ -z "$newUserShell" ] #empty ?
                then 
                    echo "fish is not installed in your system. Installation..."
                    sudo apt-get install fish -y 1> /dev/null
                    newUserShell=$(command -v fish)
                fi
                finished=1
                ;;

            "8") # other
                echo -n "Enter the name of the shell you want to use : "
                read userShellInput
                newUserShell=$(command -v $userShellInput)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "$userShellInput is not installed in your system. Installation..."
                    sudo apt-get install $userShellInput -y 1> /dev/null
                    if [ $? -eq 0 ]; #verify previous command
                    then 
                        newUserShell=$(command -v $userShellInput);
                    else    
                        echo "End with error code : $?"
                        exit $?;
                    fi                    
                fi
                finished=1
                ;;

            *) 
                echo "Please choose one of the shells."
        esac
    done

    echo "New shell : $newUserShell";
    echo "";
}

function askShell() {
    printShells;
    local finished=0;
    while [ $finished -eq 0 ]
    do
        read shellOption;
        case $shellOption in 
            "1") # bash
                userShell=$(command -v bash)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "bash is not installed in your system. Installation..."
                    sudo apt-get install bash -y 1> /dev/null
                    userShell=$(command -v bash)
                fi
                finished=1
                ;;

            "2") # sh
                userShell=$(command -v sh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "sh is not installed in your system. Installation..."
                    sudo apt-get install sh -y 1> /dev/null
                    userShell=$(command -v sh)
                fi
                finished=1
                ;;

            "3") # dash
                userShell=$(command -v dash)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "dash is not installed in your system. Installation..."
                    sudo apt-get install dash -y 1> /dev/null
                    userShell=$(command -v dash)
                fi
                finished=1
                ;;
            
            "4") # zsh
                userShell=$(command -v zsh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "zsh is not installed in your system. Installation..."
                    sudo apt-get install zsh -y 1> /dev/null
                    userShell=$(command -v zsh)
                fi
                finished=1
                ;;

            "5") #ksh 
                userShell=$(command -v ksh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "ksh is not installed in your system. Installation..."
                    sudo apt-get install ksh -y 1> /dev/null
                    userShell=$(command -v ksh)
                fi
                finished=1
                ;;

           "6") #tcsh
                userShell=$(command -v tcsh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "tcsh is not installed in your system. Installation..."
                    sudo apt-get install tcsh -y 1> /dev/null
                    userShell=$(command -v tcsh)
                fi
                finished=1
                ;;

           "7") #fish
                userShell=$(command -v fish)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "fish is not installed in your system. Installation..."
                    sudo apt-get install fish -y 1> /dev/null
                    userShell=$(command -v fish)
                fi
                finished=1
                ;;

            "8") # other
                echo -n "Enter the name of the shell you want to use : "
                read userShellInput
                userShell=$(command -v $userShellInput)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "$userShellInput is not installed in your system. Installation..."
                    sudo apt-get install $userShellInput -y 1> /dev/null
                    if [ $? -eq 0 ]; #verify previous command
                    then 
                        userShell=$(command -v $userShellInput);
                    else    
                        echo "End with error code : $?"
                        exit $?;
                    fi                    
                fi
                finished=1
                ;;

            *) 
                echo "Please choose one of the shells."
        esac
    done

    echo "Shell : $userShell";
    echo "";
}

# askId()
# Lets the user decide which id to give to the new user
function askId() {
    local finished=0;
    while [ $finished -eq 0 ]
    do
        echo -n "Type user id : "
        read userId

        if ! [[ $userId =~ ^[0-9]+$ ]] # is a number ?
        then 
            echo "You did not enter a number. Try again";

        elif [ $userId -le 0 ] #positive ?
        then 
            echo "Please type a strictly positive number";

        else 
            sudo useradd trsxfzecbudrgfrezvrvztvrgr -u $userId 1> /dev/null 2> /dev/null # to check if the userId is unique
            if [ $? -eq 0 ] # previous command success
            then 
                finished=1;
            else # previous command failure
                echo "The user identifier $userId (UID) is not unique. Try again."
            fi  
        fi
    done

    sudo userdel trsxfzecbudrgfrezvrvztvrgr 1> /dev/null 2> /dev/null #delete the random user

    echo "User id : $userId"
    echo "";
}

# askNewId()
function askNewId() {
    local finished=0;
    while [ $finished -eq 0 ]
    do
        echo -n "Type user id : "
        read newUserId

        if ! [[ $newUserId =~ ^[0-9]+$ ]] # is a number ?
        then 
            echo "You did not enter a number. Try again";

        elif [ $newUserId -le 0 ] #positive ?
        then 
            echo "Please type a strictly positive number";

        else 
            sudo useradd trsxfzecbudrgfrezvrvztvrgr -u $newUserId 1> /dev/null 2> /dev/null # to check if the userId is unique
            if [ $? -eq 0 ] # previous command success
            then 
                finished=1;
            else # previous command failure
                echo "The user identifier $newUserId (UID) is not unique. Try again."
            fi  
        fi
    done

    sudo userdel trsxfzecbudrgfrezvrvztvrgr 1> /dev/null 2> /dev/null #delete the random user

    echo "New user id : $newUserId"
    echo "";
}

# askDeletionOfHomeDirectory
# Asks wether the home directory of the user should be deleted
function askDeletionOfHomeDirectory() {
    local finished=0;
    while [ $finished -eq 0 ] 
    do
        read -p "Do you want to delete the home directory of the user (y/n) ?" yn;
        case $yn in
            [Yy]* ) 
                deleteHomeDir=1; 
                break
                ;;

            [Nn]* ) 
                deleteHomeDir=0; 
                break
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done
}

# askDeletionLoggedUser()
# Asks wether the user should be deleted even though he is connected
function askDeletionLoggedUser() {
    local finished=0;
    while [ $finished -eq 0 ] 
    do
        read -p "Do you want to force the deletion of the user even though he is connected (y/n) ? Note that it could let your system in an instable state." yn;
        case $yn in
            [Yy]* ) 
                forceDeletion=1; 
                break
                ;;

            [Nn]* ) 
                forceDeletion=0; 
                break
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done
}

function askUserModifications() {
    local finished=0;

    while [ $finished -eq 0 ]; do
        read -p "Do you want to update $userToUpdate's name ?" yn; # update name ?
        case $yn in
            [Yy]* ) 
                askNewUsername; 
                updateUsername=1;
                finished=1;
                ;;

            [Nn]* ) 
                finished=1;
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done

    finished=0;
    while [ $finished -eq 0 ]; do
        read -p "Do you want to update $userToUpdate's directory ?" yn; # update directory ?
        case $yn in
            [Yy]* ) 
                askNewUserHomeDirectory; 
                updateDirectory=1;
                finished=1;
                ;;

            [Nn]* ) 
                finished=1;
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done

    finished=0;
    while [ $finished -eq 0 ]; do
        read -p "Do you want to update $userToUpdate's expiration date ?" yn; # update date ?
        case $yn in
            [Yy]* ) 
                askNewExpirationDate; 
                updateExpirationDate=1;
                finished=1;
                ;;

            [Nn]* ) 
                finished=1;
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done

    finished=0;
    while [ $finished -eq 0 ]; do
        read -p "Do you want to update $userToUpdate's password ?" yn; # update password ?
        case $yn in
            [Yy]* )  
                sudo passwd $userToUpdate;
                finished=1;
                ;;

            [Nn]* ) 
                finished=1;
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done

    finished=0;
    while [ $finished -eq 0 ]; do
        read -p "Do you want to update $userToUpdate's shell ?" yn; # update shell ?
        case $yn in
            [Yy]* )  
                askNewShell;
                updateShell=1;
                finished=1;
                ;;

            [Nn]* ) 
                finished=1;
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done

    finished=0;
    while [ $finished -eq 0 ]; do
        read -p "Do you want to update $userToUpdate's UID ?" yn; # update UID ?
        case $yn in
            [Yy]* )  
                askNewId;
                updateUID=1;
                finished=1;
                ;;

            [Nn]* ) 
                finished=1;
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done

    finished=0;
    while [ $finished -eq 0 ]; do
        read -p "Do you want to add $userToUpdate to sudoers ?" yn;
        case $yn in
            [Yy]* )  
                addToSudoers=1;
                finished=1;
                ;;

            [Nn]* ) 
                finished=1;
                ;;

            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done
}


