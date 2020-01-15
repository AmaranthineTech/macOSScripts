#!/bin/bash

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
# sudo sh ./createUserAccount.sh -username <USERNAME> -password <PASSWORD> -accountType <ACCOUNTTYPE> -realName <REALNAME> -primaryGroupID <PRIMARYGROUPID>
# sudo sh ./createUserAccount.sh -username ladmin -password ladminpwd -accountType admin -realName "Local Admin" -primaryGroupID 80
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""

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
    echo "sudo sh ./resetUserPassword.sh <USERNAME> <NEW PASSWORD>"
    echo "For Example"
    echo "sudo sh ./createUserAccount.sh ladmin ladminpwd admin ""Local Admin"" 80"
    exit 1
fi

echo $USERNAME $PASSWORD

. /etc/rc.common

#4. Create the user
#Before creating the user we need to make sure the user doesn't already exist.
if [[ $USERNAME != `dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $USERNAME` ]]; then
    echo "The User does not exist. Please check username"
    exit 0
fi

#5. Set the shell
dscl . create /Users/$USERNAME UserShell /bin/bash

#6. Set the real name
dscl . create /Users/$USERNAME RealName "$REALNAME"

#7. Set the Unique ID
LASTUSEDID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
echo $LASTUSEDID
NEXTAVAILABLEID=$((LASTUSEDID + 1))

dscl . create /Users/$USERNAME UniqueID $NEXTAVAILABLEID

#8. Set the Primary Group
dscl . create /Users/$USERNAME PrimaryGroupID $PRIMARYGROUPID

#9. Set the password
dscl . passwd /Users/$USERNAME $PASSWORD

#10. Create the Home Directory
dscl . create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
createhomedir -u $USERNAME -c

#11. Add to admin group if account type is admin
if [[ $ACCOUNTTYPE == "admin" ]];
then
    dscl . -append /Groups/admin GroupMembership $USERNAME
fi
