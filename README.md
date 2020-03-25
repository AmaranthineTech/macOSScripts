# macOSScripts
The scripts can be used to configure different settings in macOS. The can also be used to perform different tasks.

**The scripts provided here will have to be modified to suit your needs. A lot of assumptions have been made especially on availability of resources and folder locations.  _Please test it out before using it._**

# Disclaimer
_The Software Is Provided "As Is", Without Warranty Of Any Kind, Express Or Implied, Including But Not Limited To The Warranties Of Merchantability, Fitness For A Particular Purpose And Noninfringement. In No Event Shall The Authors Or Copyright Holders Be Liable For Any Claim, Damages Or Other Liability, Whether In An Action Of Contract, Tort Or Otherwise, Arising From, Out Of Or In Connection With The Software Or The Use Or Other Dealings In The Software._

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

## Security Report
This script generates a report of some of the security settings for the device. It also uses a Swift based parser to parse the text. 

### Running the script
```Shel
sudo ./generateSecuirtyReport.sh <USERNAME> <PASSWORD>
sudo ./generateSecuirtyReport.sh ladmin ladminpwd
```

To build the csvparser:
1. Simply open the Xcode project. 
2. Press the keys: **⌘B** to build the project.
3. From the left hand side project navigator select the built executable and control click to get the secondary menu.
4. Select _*Show in Finder*_ to get the location of the executable in Finder.
5. Copy it to the location you desire and modufy the script to use the correct path.
