#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 24th January 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the login settings for a Mac.
#Arguments
     #argument 1 : Username
     #argument 2 : Password
     #argument 3 : Message to be displayed on login screen
     #argument 4 : User whose autologin is to be disabled

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
# USERNAME          : All lower case, one word. This is the administrator user account username.
# PASSWORD          : Should be a single word. This is the administrator user account password.
# MESSAGE           : Can contain multiple words in a single line within quotes. For example, "This Mac belongs to Admin."
# USER NAME         : All lower case, one word. This is the username of the user account whose auto login is to be disabled.
#
# SAMPLE USAGE
# sudo ./configureLogin.sh <USERNAME> <PASSWORD> <MESSAGE> <USER>
# sudo ./configureLogin.sh ladmin ladminpwd "This is a login window message" student
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""
LOGFILE="/Users/Shared/configureLogin.log"
MESSAGE=""
USERTODISABLE=""

#1. Check to see if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "The script must be run as root."
    exit 1
fi

#2. Assign values to variables
USERNAME=$1
PASSWORD=$2
MESSAGE=$3
USERTODISABLE=$4

#3. Check to see if all the arguments are passed
if [[ $USERNAME == "" || $PASSWORD == "" || $MESSAGE == "" || $USERTODISABLE == "" ]]; then
    echo "ERROR: Incorrect use of command. Please make sure all the arguments are passed in."
    echo "sudo ./configureLogin.sh <USERNAME> <PASSWORD> <MESSAGE> <USER>"
    echo "For Example"
    echo "sudo ./configureLogin.sh ladmin ladminpwd \"This is a login window message\" student"
    echo "Warning: Please make sure that the login window message is less than 3 lines."
    exit 1
fi

#4. Check to see if the log file exists
if [[ -f $LOGFILE ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") File exists" >> $LOGFILE
else
    cd /Users/Shared/
    touch configureLogin.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#LOGIN WINDOW MESSAGE ---------------------------------------------
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText $MESSAGE

#DISABLE AUTOLOGIN -------------------------------------------------
#Check to see if the user exists
if [[ $USERTODISABLE != `dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $USERNAME` ]]; then
    echo "The User does not exist. Please check the username"
    exit 0
fi
#check to see if there is any autologin configured for a given user
PRECONFIGUREDUSER=$(defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser)

if [[ $PRECONFIGUREDUSER != "" && $PRECONFIGUREDUSER == $USERTODISABLE ]];
then
    defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser $USERTODISABLE
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") $USERTODISABLE autoLogin disabled" >> $LOGFILE
else
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Auto login not configured or configured for another user." >> $LOGFILE"
fi

#SHOW MORE DETAILS ------------------------------------------------
#To view the values in the login window simply click on the clock in the upper right hand corner to cycle through the values below.
defaults write /Library/Preferences/com.apple.loginwindow.plist AdminHostInfo SystemVersion
defaults write /Library/Preferences/com.apple.loginwindow.plist AdminHostInfo SystemBuild
defaults write /Library/Preferences/com.apple.loginwindow.plist AdminHostInfo SerialNumber
defaults write /Library/Preferences/com.apple.loginwindow.plist AdminHostInfo DSStatus

#DISABLE SHUTDOWN, SLEEP, & RESTART BUTTONS
defaults write /Library/Preferences/com.apple.loginwindow ShutDownDisabled -bool true
defaults write /Library/Preferences/com.apple.loginwindow RestartDisabled -bool true
defaults write /Library/Preferences/com.apple.loginwindow SleepDisabled -bool true

