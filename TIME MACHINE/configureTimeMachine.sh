#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 24th January 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the Time Machine settings for a Mac.
#Arguments
     #argument 1 : Username
     #argument 2 : Password
     #argument 3 : Path to destination where backups must be taken
     #argument 4 : The volume to be excluded from the backups

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root. THIS SCRIPT EXPECTS THE USER TO PROVIDE A USER ACCOUNT PASSWORD IN CLEAR TEXT. PLEASE USE CAUTION. IT WOULD BE RECOMMENDED TO MODIFY THIS SCRIPT IN A PRODUCTION ENVIRONMENT.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
# USERNAME          : All lower case, one word. This is the administrator user account username.
# PASSWORD          : Should be a single word. This is the administrator user account password.
# DESTINATION       : Must be in quotes. This must include the full path. If you are using a network volume then the protocol also must be mentioned.
#                     The user name and password for the destination must also be mentioned.
# VOLUME TO EXCLUDE : This is the volume that you want to exclude. Only one volume can be specified at a time. This script expects a non boot volume here.
#
# SAMPLE USAGE
# sudo ./configureTimeMachine.sh <USERNAME> <PASSWORD> <PATH TO DESTINATION> <VOLUME TO EXCLUDE>
# sudo ./configureTimeMachine.sh ladmin ladminpwd "afp://demouser[:demopwd]@192.168.1.100/backups/" "/Volumes/Miscellaneous/"
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""
LOGFILE="/Users/Shared/configureTimeMachine.log"
DESTINATION=""
VOLUMETOEXCLUDE=""

#1. Check to see if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "The script must be run as root."
    exit 1
fi

#2. Assign values to variables
USERNAME=$1
PASSWORD=$2
DESTINATION=$3
VOLUMETOEXCLUDE=$4

#3. Check to see if all the arguments are passed
if [[ $USERNAME == "" || $PASSWORD == "" || $DESTINATION == "" ]]; then
    echo "ERROR: Incorrect use of command. Please make sure all the arguments are passed in."
    echo "sudo ./configureTimeMachine.sh <USERNAME> <PASSWORD> <PATH TO DESTINATION> <VOLUME TO EXCLUDE>"
    echo "For Example"
    echo "sudo ./configureTimeMachine.sh ladmin ladminpwd \"afp://demouser[:demopwd]@192.168.1.100/backups/\" \"/Volumes/Miscellaneous/\""
    echo "Warning: Please make sure that the path provided is correct."
    exit 1
fi

#4. Check to see if the log file exists
if [[ -f $LOGFILE ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") File exists" >> $LOGFILE
else
    cd /Users/Shared/
    touch configureTimeMachine.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#5. TIME MACHINE BASIC CONFIGURATION
tmutil setdestination -ap $DESTINATION

#6. TIME MACHINE SYSTEM EXCLUSIONS
tmutil addexclusion -p /Library/
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Excluding /Library/ from Backup" >> $LOGFILE

tmutil addexclusion -p /Applications/
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Excluding /Applications/ from Backup" >> $LOGFILE

tmutil addexclusion -p /System/
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Excluding /System/ from Backup" >> $LOGFILE

tmutil addexclusion -p /Users/Shared/
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Excluding /Users/Shared/ from Backup" >> $LOGFILE

#7. Exclude the Applications folder in the users home folder if it exists
if [[ -d /Users/$USERNAME/Applications/ ]]
then
    tmutil addexclusion -p /Users/$USERNAME/Applications/
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Excluding /Users/$USERNAME/Applications/ from Backup" >> $LOGFILE
fi

#8. Exclusion for the path
if [[ $VOLUMETOEXCLUDE != "" ]]
then
    tmutil addexclusion -v $VOLUMETOEXCLUDE
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Excluding $VOLUMETOEXCLUDE from Backup" >> $LOGFILE
fi

#9. Turn on time machine
tmutil enable
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Turning ON automatic backups for Time Machine" >> $LOGFILE
