#!/bin/bash

: '
    printMenu()

    Prints the functionalities to the user
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

# askUsernameForDeletion()
# Let's the user write a non-empty user name and create a variable for that
function askUsernameForDeletion() {
    echo "Type the name of the user you want to delete : "
    success=0
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
            usernameTaken=$(grep $userToDelete /etc/passwd);
            if [ -z "$usernameTaken" ] #emtpy ?
            then 
                echo "User $userToDelete does not exist. Try again.";
            else
                success=1
                echo "User to delete : $userToDelete";
            fi
        fi
    done
    echo ""
}

# askUserHomeDirectory()
function askUserHomeDirectory() {
    echo "Enter the user's home directory path : "
    success=0
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
                    apt-get install bash -y 1> /dev/null
                    userShell=$(command -v bash)
                fi
                finished=1
                ;;

            "2") # sh
                userShell=$(command -v sh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "sh is not installed in your system. Installation..."
                    apt-get install sh -y 1> /dev/null
                    userShell=$(command -v sh)
                fi
                finished=1
                ;;

            "3") # dash
                userShell=$(command -v dash)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "dash is not installed in your system. Installation..."
                    apt-get install dash -y 1> /dev/null
                    userShell=$(command -v dash)
                fi
                finished=1
                ;;
            
            "4") # zsh
                userShell=$(command -v zsh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "zsh is not installed in your system. Installation..."
                    apt-get install zsh -y 1> /dev/null
                    userShell=$(command -v zsh)
                fi
                finished=1
                ;;

            "5") #ksh 
                userShell=$(command -v ksh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "ksh is not installed in your system. Installation..."
                    apt-get install ksh -y 1> /dev/null
                    userShell=$(command -v ksh)
                fi
                finished=1
                ;;

           "6") #tcsh
                userShell=$(command -v tcsh)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "tcsh is not installed in your system. Installation..."
                    apt-get install tcsh -y 1> /dev/null
                    userShell=$(command -v tcsh)
                fi
                finished=1
                ;;

           "7") #fish
                userShell=$(command -v fish)
                if [ -z "$userShell" ] #empty ?
                then 
                    echo "fish is not installed in your system. Installation..."
                    apt-get install fish -y 1> /dev/null
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
                    apt-get install $userShellInput -y 1> /dev/null
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

# askDeletionOfHomeDirectory
# Asks wether the home directory of the user should be deleted
function askDeletionOfHomeDirectory() {
    local finished=0;
    while [ finished -eq 0 ] 
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
    while [ finished -eq 0 ] 
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

# handleUserInput()
# Calls the right functions depending on the user choice
function handleUserInput() {
    while true
    do
        read option;
        case $option in 
            "1")
                createUser
                exit 0;
                ;;

            "2")
                echo "Update"
                exit 0;
                ;;

            "3")
                deleteUser
                exit 0;
                ;;
            
            "4")
                echo "Bye !"
                exit 0;
                ;;

            *) 
                echo "Please choose one of the above options (1-4)"
        esac
    done
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
}

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
: '
    main()
    Calls all the main functions
'
function main() {
    setLanguage;
    forceRoot;

    printMenu;
    handleUserInput;

    resetLanguage;
    exit 0;
}

main;