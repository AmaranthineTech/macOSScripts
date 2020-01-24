#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 13th January 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script examines the different security settings and prepares a report for the same.
#Arguments
     #argument 1 : Username
     #argument 2 : Password

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
# USERNAME          : All lower case, one word. This is the administrator user account username.
# PASSWORD          : Should be a single word. This is the administrator user account password.
# ACCOUNT TYPE      : One Word, "admin", "standard"
# REAL NAME         : Can be more than one word. If it is more than one word then it should be in quotes.
# PRIMARY GROUP ID  : Just a number. (80 -> admin, 20 -? user)
#
# SAMPLE USAGE
# ./generateSecurityReport.sh <USERNAME> <PASSWORD>
# ./generateSecurityReport.sh ladmin ladminpwd
####################################################################################################
####################################################################################################

#Variables
USERNAME=""
PASSWORD=""
REPORTNAME="/Users/Shared/Report/in.amaranthine.SECURITYREPORT.plist"
REPORTPATH="/Users/Shared/Report"
REPORTLOG="/Users/Shared/Report/report.log"

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
    echo "sudo ./generateSecurityReport.sh <USERNAME> <PASSWORD>"
    echo "For Example"
    echo "sudo ./generateSecurityReport.sh ladmin ladminpwd"
    exit 1
fi

echo $USERNAME $PASSWORD

#4. Check to see if the folder exists
if [[ -d $REPORTPATH ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Folder exists" >> $REPORTLOG
else
    cd /Users/Shared/
    mkdir Report
    cd Report
    touch report.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $REPORTLOG
fi

#SIP STATUS ----------------------------------------------------------------------------------------
SIPSTAT=$(csrutil status)
defaults write $REPORTNAME SIP "$SIPSTAT"

#GATEKEEPER STATUS ---------------------------------------------------------------------------------
GATEKEEPERSTAT=$(spctl --status)
defaults write $REPORTNAME GateKeeper "$GATEKEEPERSTAT"

#FIREWALL ------------------------------------------------------------------------------------------
FIREWALLSTAT=$(defaults read /Library/Preferences/com.apple.alf.plist)
defaults write $REPORTNAME Firewall "$FIREWALLSTAT"

##UAKEL STATUS --------------------------------------------------------------------------------------
/usr/bin/expect -c '
spawn sqlite3 /var/db/SystemPolicyConfiguration/KextPolicy
expect "sqlite>" { send ".mode csv\r"}
expect "sqlite>" { send ".output /Users/Shared/Report/macOSKextWhitelist.csv\r"}
expect "sqlite>" { send "SELECT * FROM kext_policy;\r"}
expect "sqlite>" { send ".output stdout\r"}
expect "sqlite>" { send ".quit\r"}
expect eof'

#transform to _ delimited
cat /Users/Shared/Report/macOSKextWhitelist.csv| tr "," "_" >> ~/Desktop/transformedFile.txt

#parse the file using builtin parser
~/Desktop/csvparser --file ~/Desktop/transformedFile.txt --delimiter _ --keylist ~/Desktop/keys.txt --plist $REPORTNAME

#cleanup
rm ~/Desktop/transformedFile.txt
rm /Users/Shared/Report/macOSKextWhitelist.csv

#SECURE TOKEN STATUS -------------------------------------------------------------------------------
#4. Get list of users
USERS=$(dscl . -list /Users | grep -v '_')
SECURETOKENENABLEDUSERS=()

for person in $USERS
do
    sysadminctl -secureTokenStatus $person 2> $REPORTPATH/TOKENSTAT.log

    STR=$(grep -w "ENABLED" $REPORTPATH/TOKENSTAT.log)

    if [[ $STR != "" ]]
    then
        SECURETOKENENABLEDUSERS+=($person)
    fi
done

COMMAND="("
for human in ${SECURETOKENENABLEDUSERS[@]}
do
    if [[ $COMMAND == "(" ]]
    then
        COMMAND=$(echo "$COMMAND $human")
    else
        COMMAND=$(echo "$COMMAND, $human")
    fi
done
COMMAND=$(echo "$COMMAND )")

#write to report
defaults write $REPORTNAME SecureTokenEnabledUsers -array "$COMMAND"

#cleanup
rm $REPORTPATH/TOKENSTAT.log

#FILEVAULT STATUS ----------------------------------------------------------------------------------
FVISON=$(echo ""$(fdesetup isactive)"")
FVSTATUS=$(echo ""$(fdesetup status)"")
FVKEYTYPE=" "

ISACTIVE=$(fdesetup isactive)
FVPERSONALKEY=""
FVINSTITKEY=""
if [[ $ISACTIVE == "true" ]]; then
    FVPERSONALKEY=$(fdesetup haspersonalrecoverykey)
    FVINSTITKEY=$(fdesetup hasinstitutionalrecoverykey)

    if [[ $FVPERSONALKEY == "true" ]]; then
        FVKEYTYPE="Personal"
    elif [[ $FVINSTITKEY == "true" ]]; then
        FVKEYTYPE="Institutional"
    fi
fi
echo $FVSTATUS

#write to report
defaults write $REPORTNAME FileVaultInfo -dict-add IsActive "$FVISON"
defaults write $REPORTNAME FileVaultInfo -dict-add Status "$FVSTATUS"
defaults write $REPORTNAME FileVaultInfo -dict-add FileVaultKeyType "$FVKEYTYPE"
