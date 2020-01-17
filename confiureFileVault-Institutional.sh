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
#OPTION 2 - Use institutional deployment

#7. Export the variables for use in Expect script
export USERNAME
export PASSWORD
export FDERECOVERKEYPATH

#8. Change the permissions for the FileVault Master Key
cp ~/Desktop/FileVaultMaster.keychain /Library/Keychains/
chown root:wheel /Library/Keychains/FileVaultMaster.keychain
chmod 644 /Library/Keychains/FileVaultMaster.keychain

#9. If we are turning on FileVault for the first time, then turn it on using the Master Key. Else change the receovery key method to Institutional.
if [[ $TURNONFILEVAULT == "TRUE" ]]; then
    /usr/bin/expect -c '
    set myUserName $env(USERNAME);
    set myPassword $env(PASSWORD);
    spawn fdesetup enable -keychain -norecoverykey
    expect "Enter the user name:" { send "$myUserName\r"}
    expect "Enter the password for user ?" { send "$myPassword\r"}
    expect eof'
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") Turning on FileVault" >> $FDECONFIGLOG
else
    fdesetup changerecovery -institutional -keychain /Library/Keychains/FileVaultMaster.keychain
    echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S") Since FileVault is already tunred on, only changing the recovery key to institutional" >> $FDECONFIGLOG
fi

echo "$(date "+DATE: %Y-%m-%d% TIME: %H:%M:%S")" >> $FDECONFIGLOG
fdesetup status >> $FDECONFIGLOG
