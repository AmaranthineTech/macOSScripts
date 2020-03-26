#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 26th March 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script keeps the system awake.
#Arguments

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root. THIS SCRIPT EXPECTS THE USER TO PROVIDE A USER ACCOUNT PASSWORD IN CLEAR TEXT. PLEASE USE CAUTION. IT WOULD BE RECOMMENDED TO MODIFY THIS SCRIPT IN A PRODUCTION ENVIRONMENT.

####################################################################################################
####################################################################################################
# SAMPLE USAGE
# sudo ./keepAwake.sh
####################################################################################################
####################################################################################################

#Variables
LOGFILE="/Users/Shared/keepAwake.log"

#1. Check to see if the log file exists
if [[ -f $LOGFILE ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") File exists" >> $LOGFILE
else
    cd /Users/Shared/
    touch keepAwake.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#2. Schedule weekday shutdown
caffeinate -dimsu
