# macOSScripts
The scripts can be used to configure different settings in macOS. The can also be used to perform different tasks.

**The scripts provided here will have to be modified to suit your needs. A lot of assumptions have been made especially on availability of resources and folder locations.  _Please test it out before using it._**

# Disclaimer
_The Software Is Provided "As Is", Without Warranty Of Any Kind, Express Or Implied, Including But Not Limited To The Warranties Of Merchantability, Fitness For A Particular Purpose And Noninfringement. In No Event Shall The Authors Or Copyright Holders Be Liable For Any Claim, Damages Or Other Liability, Whether In An Action Of Contract, Tort Or Otherwise, Arising From, Out Of Or In Connection With The Software Or The Use Or Other Dealings In The Software._

---
## User Accounts & Settings

### User Account Creation
This script walks through the process of creating a user account.

#### Running the script
Template: `sudo sh ./createUserAccount.sh <USERNAME> <PASSWORD> <ACCOUNTTYPE> <REALNAME> <PRIMARYGROUPID>`
```SHELL
sudo sh ./createUserAccount.sh ladmin ladminpwd admin "Local Admin" 80
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SETTINGS/createUserAccount.sh



### Network Configuration
The network configuration script walks through some of the items that can be configured within Network preferences. This script needs to be run as root.

#### Running the script
Template: 
```Shell
sudo sh ./configureNetwork.sh <LOCATION> <INTERFACE NAME> <INTERFACE TYPE> <IP ADDRESS> <SUBNET> <ROUTER ADDRESS> <DNS ADDRESS> <SEARCH DOMAIN>
sudo sh ./configureNetwork.sh Classroom Classroom Wi-Fi 192.168.1.100 255.255.0.0 192.168.1.1 192.168.1.1 amaranthine.in
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SETTINGS/configureNetwork.sh



### Energy Settings Configuration
This configures energy settings and generates a report for the same.

#### Running the Script
```Shell
sudo ./configureEnergyManagement.sh
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SETTINGS/ENERGY/configureEnergyManagement.sh



### Keep Awake
This script keeps the computer running till the caffeinate process is killed.

#### Running the script
```Shell
./keepAwake.sh
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SETTINGS/ENERGY/keepAwake.sh



### Miscellaneous Commands
A collection of different commands. 

#### Running the script
While you can run the script in one go, it might be a good idea to try out the different commands one by one.
```Shell
./configureSettings.sh
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SETTINGS/Miscellaneous/configureSettings.sh

---
## Security

### Keychain

#### Running the script
```Shell
./exploreKeychain.sh
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SECURITY/KEYCHAIN/exploreKeychain.sh



### FileVault
There are 2 versions of the script. One which uses the defer method. The other uses the Institutional Key method. Read [this](https://support.apple.com/en-in/HT202385) article to learn how to create institutional recovery keys.

#### Running the script
Template: `sudo sh ./configureFileVault.sh <USERNAME> <PASSWORD>`
```Shell
sudo sh ./configureFileVault.sh ladmin ladminpwd
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SECURITY/FILEVAULT/confiureFileVault-Defer.sh
https://github.com/AmaranthineTech/macOSScripts/blob/master/SECURITY/FILEVAULT/confiureFileVault-Institutional.sh



### Security Report
This script generates a report of some of the security settings for the device. It also uses a Swift based parser to parse the text. 

#### Running the script
Template:`sudo ./generateSecuirtyReport.sh <USERNAME> <PASSWORD>`
```Shell
sudo ./generateSecuirtyReport.sh ladmin ladminpwd
```

To build the csvparser:
1. Simply open the Xcode project. 
2. Press the keys: **⌘B** to build the project.
3. From the left hand side project navigator select the built executable and control click to get the secondary menu.
4. Select _*Show in Finder*_ to get the location of the executable in Finder.
5. Copy it to the location you desire and modufy the script to use the correct path.

#### Script
https://github.com/AmaranthineTech/macOSScripts/tree/master/SECURITY/SECURITY%20REPORT



### Login
This script configures the login window and disable autologin.

#### Running the script
Template:`sudo ./configureLogin.sh <USERNAME> <PASSWORD> <MESSAGE> <USER>`
```Shell
sudo ./configureLogin.sh ladmin ladminpwd "This is a login window message" student
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/SECURITY/LOGIN/configureLogin.sh




---
## Data

### Time Machine Setup
This script configures time machine settings for a Mac.

#### Running the script
Template: `sudo ./configureTimeMachine.sh <USERNAME> <PASSWORD> <PATH TO DESTINATION> <VOLUME TO EXCLUDE>`
```Shell
sudo ./configureTimeMachine.sh ladmin ladminpwd "afp://demouser[:demopwd]@192.168.1.100/backups/" "/Volumes/Miscellaneous/"
```
OR
```Shell
sudo ./configureTimeMachine.sh ladmin ladminpwd "/Volumes/BackupDrive/" "/Volumes/Miscellaneous/"
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/DATA/TIME%20MACHINE/configureTimeMachine.sh



### Configuring Content Caching
This script configures content caching on the target Mac and generates a report for the same.

#### Running the script
Template: `sudo ./configureContentCaching.sh <USERNAME> <PASSWORD>`
```Shell
sudo ./configureContentCaching.sh ladmin ladminpwd
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/DATA/CONTENT%20CACHING/configureContentCaching.sh



### Creating Disk Images
This script creates a disk image. 

#### Running the script
Template: `sudo ./configureDiskImages.sh <USERNAME> <PASSWORD> <SIZE> <NAME> <PASSWORD>`
```Shell
sudo ./configureDiskImages.sh ladmin ladminpwd 100 "Data" "pwd"
```
OR
```Shell
sudo ./configureDiskImages.sh ladmin ladminpwd 100 "Data"
```

#### Script
https://github.com/AmaranthineTech/macOSScripts/blob/master/DATA/DISK%20IMAGES/configureDiskImages.sh




---
## Information

### Generating System Information Reports
This script generates multiple reports detailing information about the system.

#### Running the Script
```Shell
./collectionSystemInformation.sh
```

#### Scripts
https://github.com/AmaranthineTech/macOSScripts/blob/master/INFORMATION/SYSTEM%20INFO/collectSystemInformation.sh
