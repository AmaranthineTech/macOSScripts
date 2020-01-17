#!/bin/bash

#Author     : Arun Patwardhan
#Date       : 14th January 2020
#Contact    : arun@amaranthine.co.in
#Website    : https://www.amaranthine.in
#Scope      : This script populates the keychain with some predefined secrets
#Arguments  : This script does not take any arguments

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root.

####################################################################################################
####################################################################################################
# SAMPLE USAGE
# ./exploreKeychain.sh

####################################################################################################
####################################################################################################

#Variables
#This variable get us access to the last keychain in the list. It assumes that only the default keychain exists.
KEYCHAINNAME=`security list-keychains | awk '{print $1}' | sort -n | tail -1`

#4. Add an internet item to the keychain
security add-internet-password -a student@mail.com -s www.mail.com -w studentPassword $KEYCHAINNAME

#5. Find an internet password
security find-internet-password -a student@mail.com -s www.mail.com -g

#6. Export all keychain items
security export -k $KEYCHAINNAME -P passcode -f pkcs12 -o ~/Desktop/secFile.p12

#View other scripts for security related changes.
