#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 25th March 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the Content Caching settings for a Mac.
#Arguments
     #argument 1 : Username
     #argument 2 : Password

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root. THIS SCRIPT EXPECTS THE USER TO PROVIDE A USER ACCOUNT PASSWORD IN CLEAR TEXT. PLEASE USE CAUTION. IT WOULD BE RECOMMENDED TO MODIFY THIS SCRIPT IN A PRODUCTION ENVIRONMENT.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
# USERNAME          : All lower case, one word. This is the administrator user account username.
# PASSWORD          : Should be a single word. This is the administrator user account password.
#
# SAMPLE USAGE
# sudo ./configureContentCaching.sh <USERNAME> <PASSWORD>
# sudo ./configureContentCaching.sh ladmin ladminpwd
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""
LOGFILE="/Users/Shared/configureContentCaching.log"
CACHINGREPORT="/Users/Shared/contentCachingReport.plist"
TEMPREPORT="/Users/Shared/temp.json"
ISACTIVATED=""

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
    echo "sudo ./configureContentCaching.sh <USERNAME> <PASSWORD>"
    echo "For Example"
    echo "sudo ./configureContentCaching.sh ladmin ladminpwd"
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

#5. Turn on Content Caching
ISACTIVATED=$(AssetCacheManagerUtil -j activate)

echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") $ISACTIVATED " >> $LOGFILE

#6. Generate Content Caching Report
echo "{\"AssetCacheManagerUtil\":" >> $TEMPREPORT
AssetCacheManagerUtil -j status >> $TEMPREPORT
echo ", \"AssetCacheLocatorUtil\":" >> $TEMPREPORT
AssetCacheLocatorUtil -j >> $TEMPREPORT
echo "}" >> $TEMPREPORT

if [[ -f $CACHINGREPORT ]]
then
    rm $CACHINGREPORT
fi

plutil -convert xml1 $TEMPREPORT -o $CACHINGREPORT
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Content Caching status report generated." >> $LOGFILE

#7. Cleanup
rm $TEMPREPORT

