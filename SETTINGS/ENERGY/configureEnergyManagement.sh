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
# sudo ./configureEnergyManagement.sh
####################################################################################################
####################################################################################################

#Variables
LOGFILE="/Users/Shared/configureEnergyManagement.log"
ENERGYMANAGEMENTREPORT="/Users/Shared/EnergyManagementReport.plist"
COMPREHENSIVEREPORT="/Users/Shared/ComprehensiveEnergyManagementReport.txt"

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
    touch configureEnergyManagement.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#3. Schedule weekday shutdown
pmset repeat shutdown MTWRF 19:00:00
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Scheduling shutdown from Monday through Friday at 7:00 PM" >> $LOGFILE

#4. Enable power nap
pmset powernap 1
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Enabling powernap." >> $LOGFILE

#5. Generate report
defaults write $ENERGYMANAGEMENTREPORT PowerSource -dict-add Battery "$(pmset -g batt)"
defaults write $ENERGYMANAGEMENTREPORT PowerSource -dict-add Adapter "$(pmset -g adapter)"

defaults write $ENERGYMANAGEMENTREPORT SleepWake -dict-add Events "$(pmset -g sched)"
defaults write $ENERGYMANAGEMENTREPORT SleepWake -dict-add Count "$(pmset -g stats)"

defaults write $ENERGYMANAGEMENTREPORT Thermal -dict-add ThermalEvents "$(pmset -g therm)"

pmset -g everything >> $COMPREHENSIVEREPORT
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Generating energy report." >> $LOGFILE
