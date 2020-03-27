#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 25th March 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the Content Caching settings for a Mac.

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
# USERNAME          : All lower case, one word. This is the administrator user account username.
# PASSWORD          : Should be a single word. This is the administrator user account password.
#
# SAMPLE USAGE
# sudo ./collectDiskInformation.sh
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""
FOLDER="/Users/Shared"
LOGFILE="$FOLDER/collectDiskInformation.log"
DISKREPORTS="$FOLDER/DiskReports"
DISKLIST="$DISKREPORTS/in.amaranthine.diskList.plist"
DISKINFO="$DISKREPORTS/in.amaranthine.diskReport.plist"
DISKFS="$DISKREPORTS/in.amaranthine.availableFileSystems.plist"
APFSLIST="$DISKREPORTS/in.amaranthine.apfsList.plist"
APFSCRYPTOUSERS="$DISKREPORTS/in.amaranthine.apfsCryptoUsers.plist"

#1. Check to see if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "The script must be run as root."
    exit 1
fi

#2. Check to see if the log file exists
if [[ -f $LOGFILE ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") File exists" >> $LOGFILE
else
    cd /Users/Shared/
    touch collectDiskInformation.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#3. Check to see if the Disk reports folder exists, else create it
if [[ -d $DISKREPORTS ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Reports folder exists." >> $LOGFILE
else
    cd $FOLDER
    mkdir DiskReports
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created reports folder." >> $LOGFILE
fi

#4. Generate disk list report
diskutil list -plist >> $DISKLIST
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Disk List report created." >> $LOGFILE

#5. Generate volume report
diskutil info -plist / >> $DISKINFO
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Volume info report created." >> $LOGFILE

#6. List of available File System formats
diskutil listfilesystems -plist >> $DISKFS
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") FileSystem report created." >> $LOGFILE

#7. APFS List
diskutil apfs list -plist >> $APFSLIST
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") List of APFS volumes created." >> $LOGFILE

#8. APFS CryptoUsers
diskutil apfs listCryptoUsers -plist / >> $APFSCRYPTOUSERS
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Crypto Users list created." >> $LOGFILE

#9. Compres all reports
zip -r DiskReports.zip $DISKREPORTS
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Archive of reports created." >> $LOGFILE

#10. Cleanup
rm -r $DISKREPORTS
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Cleanup done." >> $LOGFILE
