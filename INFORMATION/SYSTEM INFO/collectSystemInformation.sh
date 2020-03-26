#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 26th March 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the Disk images.
#Arguments

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root. THIS SCRIPT EXPECTS THE USER TO PROVIDE A USER ACCOUNT PASSWORD IN CLEAR TEXT. PLEASE USE CAUTION. IT WOULD BE RECOMMENDED TO MODIFY THIS SCRIPT IN A PRODUCTION ENVIRONMENT.

####################################################################################################
####################################################################################################
# SAMPLE USAGE
# sudo ./collectSystemInformation.sh
####################################################################################################
####################################################################################################

#Variables
LOGFILE="/Users/Shared/collectSystemInformation.log"
REPORTSPATH="/Users/Shared/SYSTEMINFOMRATIONREPORTS"
REGISTRYREPORT="$REPORTSPATH/systemIORegistryReport.plist"
PROFILERREPORT="$REPORTSPATH/systemProfilerReport.plist"
TEMPPROFILE="$REPORTSPATH/tempreport.json"
SOFTWAREREPORT="$REPORTSPATH/computerReport.plist"
COMPRESSEDREPORTS="/Users/Shared/reports.zip"


#1. Check to see if the log file exists
if [[ -f $LOGFILE ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") File exists" >> $LOGFILE
else
    cd /Users/Shared/
    touch configureContentCaching.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#2. Create the SYSTEMINFOMRATIONREPORTS/ folder
if [[ -d $REPORTSPATH/ ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Reports folder exists" >> $LOGFILE
else
    cd /Users/Shared/
    mkdir SYSTEMINFOMRATIONREPORTS
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created reports folder" >> $LOGFILE
fi

#3. Generate IORegistry Report
ioreg -la >> $REGISTRYREPORT
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Generated IORegistry Report at $REGISTRYREPORT" >> $LOGFILE
echo "Generated IORegistry Report at $REGISTRYREPORT"

#4. Generate System Profile Report
system_profiler -detaillevel full -json >> $TEMPPROFILE
plutil -convert xml1 $TEMPPROFILE -o $PROFILERREPORT

rm $TEMPPROFILE
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Generated System Profile Report at $PROFILERREPORT" >> $LOGFILE
echo "Generated System Profile Report at $PROFILERREPORT"

#5. Computer Report
defaults write $SOFTWAREREPORT SoftwareDetails -dict-add ProductName "$(sw_vers -productName)"
defaults write $SOFTWAREREPORT SoftwareDetails -dict-add OSVersion "$(sw_vers -productVersion)"
defaults write $SOFTWAREREPORT SoftwareDetails -dict-add OSBuildVersion "$(sw_vers -buildVersion)"
defaults write $SOFTWAREREPORT HardwareDetails -dict-add ProcessorArchitecture "$(uname -p)"
defaults write $SOFTWAREREPORT HardwareDetails -dict-add HardwareName "$(uname -m)"

echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Generated Computer Report at $SOFTWAREREPORT" >> $LOGFILE
echo "Generated Computer Report at $SOFTWAREREPORT"

#6. Zip all the reports
zip -r $COMPRESSEDREPORTS $REPORTSPATH/

#7. Cleanup
rm -r $REPORTSPATH/
