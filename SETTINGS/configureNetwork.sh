#!/bin/bash

#Author  : Arun Patwardhan
#Date    : 13th January 2020
#Contact : arun@amaranthine.co.in
#Website : https://www.amaranthine.in
#Scope   : This script configures the network settings for macOS
#Arguments
     #argument 1 : Location
     #argument 2 : Interface Name
     #argument 3 : IP Address
     #arguemnt 4 : Subnet
     #argument 5 : Router
     #argument 6 : DNS
     #argument 7 : Search Domain

#NOTE       : This script must be run as sudo.
#DISCLAIMER : The author of this script provides it on an as is basis. The author is not repsonsible for any damages, loss of data or any other issue that may occur with
#             the use of this script. The user of this script must take due care to validate the script before use.
#WARNING    : Use caution while running scripts as root.

####################################################################################################
####################################################################################################
# VALUE FORMAT FOR THE ARGUMENTS
#
# LOCATION      : Single word as a string. 'Classroom'
# INTERFACENAME : Single word as a string. 'Classroom'
# INTERFACETYPE : This can be more than one word. If it is more than one word then place it in quotes.
#                 Run the command `networksetup -listallhardwareports` to get a list of available ports.
# IPADDRESS     : It should be in IP Address format. 192.168.1.29
# SUBNETADDRESS : It should be in Subnet Mask format. 255.255.255.0
# ROUTERADDRESS : It should be in IP Address format. 192.168.1.1
# DNS           : It should be in IP Address format. 192.168.1.1
# SEARCHDOMAIN  : Single word with no space. Typical the search domain of the company. amaranthine.in

# SAMPLE USAGE
# sudo sh ./configureNetwork.sh <LOCATION> <INTERFACE NAME> <INTERFACE TYPE> <IP ADDRESS> <SUBNET> <ROUTER ADDRESS> <DNS ADDRESS> <SEARCH DOMAIN>
# sudo sh ./configureNetwork.sh Classroom Classroom Wi-Fi 192.168.1.100 255.255.0.0 192.168.1.1 192.168.1.1 amaranthine.in
####################################################################################################
####################################################################################################

#Variables
LOCATION=""
INTERFACENAME=""
INTERFACETYPE=""
IPADDRESS=""
SUBNETADDRESS=""
ROUTERADDRESS=""
DNS=""
SEARCHDOMAIN=""

#1. Check to see if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "The script must be run as root."
    exit 1
fi

#2. Assign values to variables
LOCATION=$1
INTERFACENAME=$2
INTERFACETYPE=$3
IPADDRESS=$4
SUBNETADDRESS=$5
ROUTERADDRESS=$6
DNS=$7
SEARCHDOMAIN=$8

#echo $1 $2 $3 $4 $5 $6 $7 $8

echo $LOCATION $INTERFACENAME $INTERFACETYPE $IPADDRESS $SUBNETADDRESS $ROUTERADDRESS $DNS $SEARCHDOMAIN

#3. Check to see if all the arguments are passed
if [[ $LOCATION == "" || $INTERFACENAME == "" || $INTERFACETYPE == "" || $IPADDRESS == "" || $SUBNETADDRESS == "" || $ROUTERADDRESS == "" || $DNS == "" || $SEARCHDOMAIN == "" ]]; then
    echo "ERROR: Incorrect use of command. Please make sure all the arguments are passed in."
    echo "sudo sh ./configureNetwork.sh <LOCATION> <INTERFACE NAME> <INTERFACE TYPE> <IP ADDRESS> <SUBNET> <ROUTER ADDRESS> <DNS ADDRESS> <SEARCH DOMAIN>"
    echo "For Example"
    echo "sudo sh ./configureNetwork.sh Classroom Classroom Wi-Fi 192.168.1.100 255.255.0.0 192.168.1.1 192.168.1.1 amaranthine.in"
    echo "For a list of available ports:"
    networksetup -listallhardwareports
    exit 1
fi

#4. Create the location & switch settings to that location
networksetup -createlocation $LOCATION
networksetup -switchtolocation $LOCATION

#5. Create the network service interface for the given hardware port
networksetup -createnetworkservice $INTERFACENAME $INTERFACETYPE

#6. Set the network settings IP Address, Subnet, Router
networksetup -setmanual Classroom $IPADDRESS $SUBNETADDRESS $ROUTERADDRESS

#7. Set the DNS Server address for the network service
networksetup -setdnsservers $INTERFACENAME $DNS

#8. Set the search domain for the given interface
networksetup -setsearchdomains $INTERFACENAME $SEARCHDOMAIN
