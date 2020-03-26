#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 26th March 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the Disk images.
#Arguments
     #argument 1 : Username
     #argument 2 : Password
     #argument 3 : Size
     #argument 4 : Volume Name
     #argument 5 : Encrytpion Password

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root. THIS SCRIPT EXPECTS THE USER TO PROVIDE A USER ACCOUNT PASSWORD IN CLEAR TEXT. PLEASE USE CAUTION. IT WOULD BE RECOMMENDED TO MODIFY THIS SCRIPT IN A PRODUCTION ENVIRONMENT.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
# USERNAME              : All lower case, one word. This is the administrator user account username.
# PASSWORD              : Should be a single word. This is the administrator user account password.
# SIZE                  : This is the size of the disk image in MB
# VOLUME NAME           : This is the name that will be given to the disk image and the mounted volume.
# ENCRYPTION PASSWORD   : This is the password that will be used for encryption.
#
# SAMPLE USAGE
# sudo ./configureDiskImages.sh <USERNAME> <PASSWORD> <SIZE> <NAME> <PASSWORD>
# sudo ./configureDiskImages.sh ladmin ladminpwd 100 "Data" "pwd"
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""
LOGFILE="/Users/Shared/configureDiskImages.log"
SIZE=""
VOLUMENAME=""
DISKIMAGEPLIST="/Users/Shared/configureDiskImage.plist"
DISKPASSWORD=""

#1. Check to see if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "The script must be run as root."
    exit 1
fi

#2. Assign values to variables
USERNAME=$1
PASSWORD=$2
SIZE=$3
VOLUMENAME=$4
DISKPASSWORD=$5

#3. Check to see if all the arguments are passed
if [[ $USERNAME == "" || $PASSWORD == "" || $SIZE == "" || $VOLUMENAME == "" ]]; then
    echo "ERROR: Incorrect use of command. Please make sure all the arguments are passed in."
    echo "sudo ./configureDiskImages.sh <USERNAME> <PASSWORD> <SIZE> <NAME> <PASSWORD>"
    echo "For Example"
    echo "sudo ./configureDiskImages.sh ladmin ladminpwd 100 \"Data\" \"abcd1234\""
    echo "sudo ./configureDiskImages.sh ladmin ladminpwd 100 \"Data\""
    echo "Note: The size is expected in MB"
    exit 1
fi

#4. Check to see if the log file exists
if [[ -f $LOGFILE ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") File exists" >> $LOGFILE
else
    cd /Users/Shared/
    touch configureContentCaching.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#5. Create Disk image
if [[ $DISKPASSWORD == "" ]]
then
    hdiutil create -type SPARSEBUNDLE -megabytes $SIZE -fs APFS $VOLUMENAME -volname $VOLUMENAME -plist >> $DISKIMAGEPLIST
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Creating disk image without encryption." >> $LOGFILE
    echo "Disk created in $(pwd)"
else
    printf $DISKPASSWORD | hdiutil create -type SPARSEBUNDLE -megabytes $SIZE -fs APFS $VOLUMENAME -volname $VOLUMENAME -encryption -stdinpass -plist >> $DISKIMAGEPLIST
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Creating disk image with encryption." >> $LOGFILE
    echo "Disk created in $(pwd)"
fi
