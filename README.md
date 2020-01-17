# macOSScripts
The scripts can be used to configure different settings in macOS. The can also be used to perform different tasks.

**The scripts provided here will have to be modified to suit your needs. A lot of assumptions have been made especially on availability of resources and folder locations. _ _Please test it out before using it._ _**

## User Account Creation
This script walks through the process of creating a user account.

### Running the script
Template: `sudo sh ./createUserAccount.sh -username <USERNAME> -password <PASSWORD> -accountType <ACCOUNTTYPE> -realName <REALNAME> -primaryGroupID <PRIMARYGROUPID>`
```SHELL
sudo sh ./createUserAccount.sh -username ladmin -password ladminpwd -accountType admin -realName "Local Admin" -primaryGroupID 80
```

## Network Configuration
The network configuration script walks through some of the items that can be configured within Network preferences. This script needs to be run as root.

### Running the script
Template: 
```Shell
sudo sh ./configureNetwork.sh <LOCATION> <INTERFACE NAME> <INTERFACE TYPE> <IP ADDRESS> <SUBNET> <ROUTER ADDRESS> <DNS ADDRESS> <SEARCH DOMAIN>
sudo sh ./configureNetwork.sh Classroom Classroom Wi-Fi 192.168.1.100 255.255.0.0 192.168.1.1 192.168.1.1 amaranthine.in
```

## Keychain

### Running the script
```Shell
./exploreKeychain.sh
```

## FileVault
There are 2 versions of the script. One which uses the defer method. The other uses the Institutional Key method. Read [this](https://support.apple.com/en-in/HT202385) article to learn how to create institutional recovery keys.

### Running the script
Template: `sudo sh ./configureFileVault.sh <USERNAME> <PASSWORD>`
```Shell
sudo sh ./configureFileVault.sh ladmin ladminpwd
```
