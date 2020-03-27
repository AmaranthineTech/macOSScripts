#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 26th March 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the different settings.
#Arguments

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root.

####################################################################################################
####################################################################################################
# SAMPLE USAGE
# ./configureSettings.sh
####################################################################################################
####################################################################################################

#Variables
LOGFILE="/Users/Shared/configureSettings.log"

#1. Check to see if the log file exists
if [[ -f $LOGFILE ]]
then
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") File exists" >> $LOGFILE
else
    cd /Users/Shared/
    touch configureSettings.log
    echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Created Folder" >> $LOGFILE
fi

#MARK: - Screen Capture
#2. Screen capture ----------
# Update the type of image produced when screen capture is taken
defaults write com.apple.screencapture type -string "jpg"
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Setting the screen capture image type to jpg." >> $LOGFILE

# Change the location where the screenshot is saved
defaults write com.apple.screencapture location /Users/Shared/
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Changing the location where screencaptures are saved to /Users/Shared/ Folder" >> $LOGFILE

# Take a screenshot
NAME=`date "+DATE:%Y-%m-%dTIME:%H:%M:%S"`
screencapture $NAME.pdf

#MARK: - Hide Files & Folders
#3. Show all the hidden items
defaults write com.apple.finder AppleShowAllFiles -bool true
# Relaunch finder for settings to take effect
killall Finder
echo "$(date "+DATE: %Y-%m-%d%TIME: %H:%M:%S") Setting the flag to show all hidden items to true." >> $LOGFILE

#4. Hide specific items
cd ~/Desktop/
touch demofile.txt
chflags hidden demofile.txt

#5. Unhide the previous item
chflags nohidden demofile.txt

#MARK: - Metadata & Spotlight
#6. View metadata for a file
cd ~/Desktop/
mdls demofile.txt >> /Users/Shared/demofileMetadata.txt

#7. Disable spotlight search for a volume
mdutil -d /Volumes/Info/

#8. Spotlight indexing status
mdutil -s /Volumes/Info/

#9. Search with spotlight
mdfind -onlyin ~/Desktop/ demo

#10. Viewing extended attributes
cd ~/Desktop/
xattr demofile.txt
