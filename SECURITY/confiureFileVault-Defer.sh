#!/bin/sh
#!/usr/bin/expect -f

#Author  : Arun Patwardhan
#Date    : 14th January 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script creates comfigures and updates record for FileVault on macOS.
#Arguments
     #argument 1 : user Name
     #argument 2 : password

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
# USERNAME          : All lower case, one word
# PASSWORD          : Should be a single word. This is the new password value
#
# SAMPLE USAGE
# sudo sh ./configureFileVault.sh <USERNAME> <PASSWORD>
# sudo sh ./configureFileVault.sh ladmin ladminpwd
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""
FDECONFIGLOG="/Users/Shared/.fdeConfig/fdeCongif.log"
FDECONFIGPATH="/Users/Shared/.fdeConfig/"
TURNONFILEVAULT="FALSE"
FDECONFIGFILE="/Users/Shared/.fdeConfig/FDEConfigSettings.plist"

#1. Check to see if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "The script must be run as root."
    exit 1
fi

#2. Assign values to variables
USERNAME=$1
PASSWORD=$2

#3. Check to see if all the arguments are passed
if [[ $USERNAME == "" || $PASSWORD == "" ]]; then
    echo "ERROR: Incorrect use of command. Please make sure all the arguments are passed in."
    echo "sudo sh ./configureFileVault.sh <USERNAME> <NEW PASSWORD>"
    echo "For Example"
    echo "sudo sh ./configureFileVault.sh ladmin ladminpwd"
    exit 1
fi

#4. Before turning on FileVault we must to check to see if the user we need exists.
if [[ $USERNAME != $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w "$USERNAME") ]]; then
    echo "The User does not exist. Please check username"
    exit 0
fi

#5. Check to see if a temp folder to hold the recovery key can be created
if [[ -d /.fdeConfig ]]; then
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") Folder exists" >> $FDECONFIGLOG
else
    cd /Users/Shared/
    mkdir .fdeConfig
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") Creating folder" >> $FDECONFIGLOG
fi
cd $FDECONFIGPATH

#6. Check to see if FileVault is already enabled
ISACTIVE=$(fdesetup isactive)
echo "$ISACTIVE"

if [[ $ISACTIVE == "false" ]]; then
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") FileVault not on" >> $FDECONFIGLOG
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") Turning on FileVault" >> $FDECONFIGLOG
    TURNONFILEVAULT="TRUE"
fi

#----------------------------------------------------------------------------------------------------
##OPTION 1 - Defer enablement for later
#7. Check to see if the file is there or not
if [[ -f $FDECONFIGFILE ]]; then
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") Config File exists" >> $FDECONFIGLOG
else
    touch $FDECONFIGFILE
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") Creaitng Config File" >> $FDECONFIGLOG
fi

#8. Turn on filevault
if [[ $TURNONFILEVAULT == "TRUE" ]]; then
    fdesetup enable -defer $FDECONFIGPATH/FDEConfigSettings.plist
fi

echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S")" >> $FDECONFIGLOG
fdesetup status >> $FDECONFIGLOG
